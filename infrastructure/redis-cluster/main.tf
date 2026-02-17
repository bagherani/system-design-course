terraform {
  required_version = ">= 1.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Docker network for Redis cluster and app
resource "docker_network" "redis" {
  name = "redis-cluster-demo-network"
}

# Redis image
resource "docker_image" "redis" {
  name = "redis:${var.redis_version}"
}

# Data volumes for each Redis node
resource "docker_volume" "redis_node1_data" {
  name = "redis-cluster-node-1-data"
}

resource "docker_volume" "redis_node2_data" {
  name = "redis-cluster-node-2-data"
}

resource "docker_volume" "redis_node3_data" {
  name = "redis-cluster-node-3-data"
}

# Redis node 1 (cluster-enabled)
resource "docker_container" "redis_node1" {
  name  = "redis-node-1"
  image = docker_image.redis.image_id

  hostname = "redis-node-1"

  ports {
    internal = 6379
    external = var.redis_node1_port
  }

  networks_advanced {
    name = docker_network.redis.name
  }

  volumes {
    volume_name    = docker_volume.redis_node1_data.name
    container_path = "/data"
  }

  command = [
    "redis-server",
    "--cluster-enabled", "yes",
    "--cluster-config-file", "nodes.conf",
    "--cluster-node-timeout", "5000",
    "--appendonly", "yes"
  ]

  restart = "unless-stopped"
}

resource "docker_container" "redis_node2" {
  name  = "redis-node-2"
  image = docker_image.redis.image_id

  hostname = "redis-node-2"

  ports {
    internal = 6379
    external = var.redis_node2_port
  }

  networks_advanced {
    name = docker_network.redis.name
  }

  volumes {
    volume_name    = docker_volume.redis_node2_data.name
    container_path = "/data"
  }

  command = [
    "redis-server",
    "--cluster-enabled", "yes",
    "--cluster-config-file", "nodes.conf",
    "--cluster-node-timeout", "5000",
    "--appendonly", "yes"
  ]

  restart = "unless-stopped"

  depends_on = [docker_container.redis_node1]
}

resource "docker_container" "redis_node3" {
  name  = "redis-node-3"
  image = docker_image.redis.image_id

  hostname = "redis-node-3"

  ports {
    internal = 6379
    external = var.redis_node3_port
  }

  networks_advanced {
    name = docker_network.redis.name
  }

  volumes {
    volume_name    = docker_volume.redis_node3_data.name
    container_path = "/data"
  }

  command = [
    "redis-server",
    "--cluster-enabled", "yes",
    "--cluster-config-file", "nodes.conf",
    "--cluster-node-timeout", "5000",
    "--appendonly", "yes"
  ]

  restart = "unless-stopped"

  depends_on = [docker_container.redis_node2]
}

# Wait for Redis nodes to accept connections, then create the cluster (3 masters, no replicas)
resource "null_resource" "redis_cluster_init" {
  depends_on = [
    docker_container.redis_node3
  ]

  provisioner "local-exec" {
    command = <<-EOT
      set -e
      echo "Waiting for Redis nodes..."
      for i in $(seq 1 30); do
        if docker run --rm --network ${docker_network.redis.name} ${docker_image.redis.name} redis-cli -h redis-node-1 -p 6379 ping 2>/dev/null | grep -q PONG; then
          echo "Redis nodes ready."
          break
        fi
        [ $i -eq 30 ] && { echo "Timeout waiting for Redis"; exit 1; }
        sleep 2
      done
      sleep 3
      echo "Creating Redis cluster (3 masters, no replicas)..."
      docker run --rm --network ${docker_network.redis.name} ${docker_image.redis.name} \
        redis-cli --cluster create \
          redis-node-1:6379 redis-node-2:6379 redis-node-3:6379 \
          --cluster-replicas 0 --cluster-yes
      echo "Redis cluster ready."
    EOT
    interpreter = ["bash", "-c"]
  }
}

# Build LikeServiceWithDB before Docker image build
resource "null_resource" "build_like_service_with_db" {
  triggers = {
    run = timestamp()
  }

  provisioner "local-exec" {
    command     = "pnpm build --filter=like-service-with-db"
    working_dir = "${path.module}/../.."
  }

  depends_on = [null_resource.redis_cluster_init]
}

# Build the LikeServiceWithDB Docker image
resource "docker_image" "like_service_with_db" {
  name = "like-service-with-db:${var.like_service_with_db_image_tag}"
  build {
    context    = "../.."
    dockerfile = "apps/LikeServiceWithDB/Dockerfile"
  }

  depends_on = [null_resource.build_like_service_with_db]
}

# Run LikeServiceWithDB (connects to Redis cluster on same network)
resource "docker_container" "like_service_with_db" {
  name  = "like-service-with-db"
  image = docker_image.like_service_with_db.image_id

  ports {
    internal = 3000
    external = var.like_service_with_db_port
  }

  networks_advanced {
    name = docker_network.redis.name
  }

  restart = "unless-stopped"

  env = [
    "PORT=3000",
    "NODE_ENV=production",
    "SERVICE_NAME=like-service-with-db",
    "SERVICE_PORT=${var.like_service_with_db_port}",
    "REDIS_CLUSTER_NODES=redis-node-1:6379,redis-node-2:6379,redis-node-3:6379",
  ]

  depends_on = [docker_image.like_service_with_db]
}
