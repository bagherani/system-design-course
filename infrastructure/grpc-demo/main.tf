terraform {
  required_version = ">= 1.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Create a Docker network so FeedService can reach EngagementService by name
resource "docker_network" "grpc_network" {
  name = "grpc-demo-network"
}

# Build FeedService Docker image (builds app inside Dockerfile, like EngagementService)
resource "docker_image" "feed_service" {
  name = "feed-service:${var.feed_service_image_tag}"
  build {
    context    = "../.."
    dockerfile = "apps/FeedService/Dockerfile"
  }
}

# Build EngagementService Docker image (builds app inside Dockerfile)
resource "docker_image" "engagement_service" {
  name = "engagement-service:${var.engagement_service_image_tag}"
  build {
    context    = "../.."
    dockerfile = "apps/EngagementService/Dockerfile"
  }
}

# EngagementService container (Next.js on 3000, gRPC on 50051)
resource "docker_container" "engagement_service" {
  name  = "engagement-service"
  image = docker_image.engagement_service.image_id

  ports {
    internal = 3000
    external = var.engagement_http_port
  }
  ports {
    internal = 50051
    external = var.engagement_grpc_port
  }

  networks_advanced {
    name = docker_network.grpc_network.name
  }

  restart = "unless-stopped"

  env = [
    "NODE_ENV=production",
    "PORT=3000",
    "HOSTNAME=0.0.0.0",
    "ENGAGEMENT_GRPC_PORT=50051",
    "SERVICE_NAME=engagement-service",
    "SERVICE_PORT=${var.engagement_http_port}"
  ]
}

# FeedService container (calls EngagementService via gRPC at engagement-service:50051)
resource "docker_container" "feed_service" {
  name  = "feed-service"
  image = docker_image.feed_service.image_id

  ports {
    internal = 3000
    external = var.feed_service_port
  }

  networks_advanced {
    name = docker_network.grpc_network.name
  }

  restart = "unless-stopped"

  env = [
    "NODE_ENV=production",
    "PORT=3000",
    "HOSTNAME=0.0.0.0",
    "ENGAGEMENT_GRPC_ADDRESS=engagement-service:50051",
    "SERVICE_NAME=feed-service",
    "SERVICE_PORT=${var.feed_service_port}"
  ]

  depends_on = [docker_container.engagement_service]
}
