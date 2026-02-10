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

# Docker network for the Cassandra cluster
resource "docker_network" "cassandra" {
  name = "cassandra-demo-network"
}

# Pull official Cassandra image
resource "docker_image" "cassandra" {
  name = "cassandra:${var.cassandra_version}"
}

# Persistent volume for node 1 data
resource "docker_volume" "cassandra_node1_data" {
  name = "cassandra-node-1-data"
}

# Persistent volume for node 2 data
resource "docker_volume" "cassandra_node2_data" {
  name = "cassandra-node-2-data"
}

# Persistent volume for node 3 data
resource "docker_volume" "cassandra_node3_data" {
  name = "cassandra-node-3-data"
}

# Cassandra node 1 (seed node)
resource "docker_container" "cassandra_node1" {
  name  = "cassandra-node-1"
  image = docker_image.cassandra.image_id

  hostname = "cassandra-node-1"

  ports {
    internal = 9042
    external = var.cql_port_node1
  }

  networks_advanced {
    name = docker_network.cassandra.name
  }

  volumes {
    volume_name    = docker_volume.cassandra_node1_data.name
    container_path = "/var/lib/cassandra"
  }

  env = [
    "CASSANDRA_CLUSTER_NAME=${var.cluster_name}",
    "CASSANDRA_LISTEN_ADDRESS=cassandra-node-1",
    "CASSANDRA_BROADCAST_ADDRESS=cassandra-node-1",
    "CASSANDRA_SEEDS=cassandra-node-1",
    "CASSANDRA_DC=datacenter1",
    "CASSANDRA_RACK=rack1",
    "CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch",
    "MAX_HEAP_SIZE=${var.cassandra_max_heap_size}",
    "HEAP_NEWSIZE=${var.cassandra_heap_newsize}",
  ]

  restart = "unless-stopped"
}

# Cassandra node 2 (joins via seed)
resource "docker_container" "cassandra_node2" {
  name  = "cassandra-node-2"
  image = docker_image.cassandra.image_id

  hostname = "cassandra-node-2"

  ports {
    internal = 9042
    external = var.cql_port_node2
  }

  networks_advanced {
    name = docker_network.cassandra.name
  }

  volumes {
    volume_name    = docker_volume.cassandra_node2_data.name
    container_path = "/var/lib/cassandra"
  }

  env = [
    "CASSANDRA_CLUSTER_NAME=${var.cluster_name}",
    "CASSANDRA_LISTEN_ADDRESS=cassandra-node-2",
    "CASSANDRA_BROADCAST_ADDRESS=cassandra-node-2",
    "CASSANDRA_SEEDS=cassandra-node-1",
    "CASSANDRA_DC=datacenter1",
    "CASSANDRA_RACK=rack1",
    "CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch",
    "MAX_HEAP_SIZE=${var.cassandra_max_heap_size}",
    "HEAP_NEWSIZE=${var.cassandra_heap_newsize}",
  ]

  restart = "unless-stopped"

  depends_on = [docker_container.cassandra_node1]
}

# Cassandra node 3 (joins via seed)
resource "docker_container" "cassandra_node3" {
  name  = "cassandra-node-3"
  image = docker_image.cassandra.image_id

  hostname = "cassandra-node-3"

  ports {
    internal = 9042
    external = var.cql_port_node3
  }

  networks_advanced {
    name = docker_network.cassandra.name
  }

  volumes {
    volume_name    = docker_volume.cassandra_node3_data.name
    container_path = "/var/lib/cassandra"
  }

  env = [
    "CASSANDRA_CLUSTER_NAME=${var.cluster_name}",
    "CASSANDRA_LISTEN_ADDRESS=cassandra-node-3",
    "CASSANDRA_BROADCAST_ADDRESS=cassandra-node-3",
    "CASSANDRA_SEEDS=cassandra-node-1",
    "CASSANDRA_DC=datacenter1",
    "CASSANDRA_RACK=rack1",
    "CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch",
    "MAX_HEAP_SIZE=${var.cassandra_max_heap_size}",
    "HEAP_NEWSIZE=${var.cassandra_heap_newsize}",
  ]

  restart = "unless-stopped"

  depends_on = [docker_container.cassandra_node2]
}

# Wait for Cassandra to accept CQL, then create schema and insert data
resource "null_resource" "cassandra_init" {
  depends_on = [docker_container.cassandra_node3]

  provisioner "local-exec" {
    command = <<-EOT
      set -e
      echo "Waiting for Cassandra..."
      for i in $(seq 1 60); do
        if docker run --rm --network ${docker_network.cassandra.name} -v ${path.module}/scripts:/scripts ${docker_image.cassandra.name} cqlsh cassandra-node-1 -u cassandra -p cassandra -e "describe cluster" 2>/dev/null; then
          echo "CQL ready."
          break
        fi
        [ $i -eq 60 ] && { echo "Timeout waiting for Cassandra"; exit 1; }
        sleep 5
      done
      echo "Giving nodes a few seconds to settle..."
      sleep 10
      echo "Creating schema..."
      docker run --rm --network ${docker_network.cassandra.name} -v ${path.module}/scripts:/scripts -w /scripts ${docker_image.cassandra.name} cqlsh cassandra-node-1 -u cassandra -p cassandra -f /scripts/schema.cql
      echo "Inserting data..."
      docker run --rm --network ${docker_network.cassandra.name} -v ${path.module}/scripts:/scripts -w /scripts ${docker_image.cassandra.name} cqlsh cassandra-node-1 -u cassandra -p cassandra -f /scripts/insert-data.cql
      echo "Done."
    EOT
    interpreter = ["bash", "-c"]
  }
}

# Build UsersService before Docker image build
resource "null_resource" "build_users_service" {
  triggers = {
    run = timestamp()
  }

  provisioner "local-exec" {
    command     = "pnpm build --filter=users-service"
    working_dir = "${path.module}/../.."
  }

  depends_on = [null_resource.cassandra_init]
}

# Build the UsersService Docker image
resource "docker_image" "users_service" {
  name = "users-service:${var.users_service_image_tag}"
  build {
    context    = "../.."
    dockerfile = "apps/UsersService/Dockerfile"
  }

  depends_on = [null_resource.build_users_service]
}

# Run UsersService (connects to Cassandra on same network, reads with quorum)
resource "docker_container" "users_service" {
  name  = "users-service"
  image = docker_image.users_service.image_id

  ports {
    internal = 3000
    external = var.users_service_port
  }

  networks_advanced {
    name = docker_network.cassandra.name
  }

  restart = "unless-stopped"

  env = [
    "PORT=3000",
    "NODE_ENV=production",
    "SERVICE_NAME=users-service",
    "SERVICE_PORT=${var.users_service_port}",
    "CASSANDRA_CONTACT_POINTS=cassandra-node-1,cassandra-node-2,cassandra-node-3",
    "CASSANDRA_PORT=9042",
    "CASSANDRA_KEYSPACE=demo",
    "CASSANDRA_USER=cassandra",
    "CASSANDRA_PASSWORD=cassandra",
    "CASSANDRA_DATACENTER=datacenter1",
  ]

  depends_on = [docker_image.users_service]
}
