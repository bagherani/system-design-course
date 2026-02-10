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

# Docker network for PostgreSQL
resource "docker_network" "postgres" {
  name = "postgres-partitioning-network"
}

# Pull official PostgreSQL image
resource "docker_image" "postgres" {
  name = "postgres:${var.postgres_version}"
}

# Persistent volume for PostgreSQL data
resource "docker_volume" "postgres_data" {
  name = "postgres-partitioning-data"
}

# PostgreSQL container
resource "docker_container" "postgres" {
  name  = var.container_name
  image = docker_image.postgres.image_id

  ports {
    internal = 5432
    external = var.host_port
  }

  networks_advanced {
    name = docker_network.postgres.name
  }

  volumes {
    volume_name    = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }

  env = [
    "POSTGRES_PASSWORD=${var.postgres_password}",
  ]

  restart = "unless-stopped"
}

# Wait for PostgreSQL to be ready, then create demo database and partitioned table
resource "null_resource" "postgres_init" {
  depends_on = [docker_container.postgres]

  provisioner "local-exec" {
    command = <<-EOT
      set -e
      echo "Waiting for PostgreSQL..."
      for i in $(seq 1 60); do
        if docker exec ${docker_container.postgres.name} pg_isready -U postgres 2>/dev/null; then
          echo "PostgreSQL ready."
          break
        fi
        [ $i -eq 60 ] && { echo "Timeout waiting for PostgreSQL"; exit 1; }
        sleep 2
      done
      echo "Creating database..."
      docker exec ${docker_container.postgres.name} psql -U postgres -c "CREATE DATABASE demo;" || true
      echo "Creating partitioned table and partitions..."
      docker exec -i ${docker_container.postgres.name} psql -U postgres -d demo -v ON_ERROR_STOP=1 -f - < "${path.module}/scripts/schema.sql"
      echo "Inserting sample data..."
      docker exec -i ${docker_container.postgres.name} psql -U postgres -d demo -v ON_ERROR_STOP=1 -f - < "${path.module}/scripts/seed.sql"
      echo "Done."
    EOT
    interpreter = ["bash", "-c"]
  }
}
