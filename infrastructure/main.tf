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

# Create a Docker network for the services
resource "docker_network" "app_network" {
  name = "like-service-network"
}

# Build the LikeService Docker image
resource "docker_image" "like_service" {
  name = "like-service:${var.like_service_image_tag}"
  build {
    context    = ".."
    dockerfile = "apps/LikeService/Dockerfile"
  }
}

# First instance of LikeService on port 3001
resource "docker_container" "like_service_1" {
  name  = "like-service-1"
  image = docker_image.like_service.image_id

  ports {
    internal = 3000
    external = var.like_service_port_1
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  restart = "unless-stopped"

  env = [
    "PORT=3000",
    "NODE_ENV=production"
  ]
}

# Second instance of LikeService on port 3002
resource "docker_container" "like_service_2" {
  name  = "like-service-2"
  image = docker_image.like_service.image_id

  ports {
    internal = 3000
    external = var.like_service_port_2
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  restart = "unless-stopped"

  env = [
    "PORT=3000",
    "NODE_ENV=production"
  ]
}

# Create nginx configuration file
resource "docker_image" "nginx" {
  name = "nginx:alpine"
}

# Nginx container with load balancer configuration
resource "docker_container" "nginx" {
  name  = "nginx-load-balancer"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = var.nginx_port
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  volumes {
    host_path      = "${path.module}/nginx.conf"
    container_path = "/etc/nginx/nginx.conf"
    read_only      = true
  }

  restart = "unless-stopped"

  depends_on = [
    docker_container.like_service_1,
    docker_container.like_service_2
  ]
}
