output "nginx_url" {
  description = "URL to access the application through nginx load balancer"
  value       = "http://localhost:${var.nginx_port}"
}

output "like_service_1_url" {
  description = "Direct URL to first LikeService instance"
  value       = "http://localhost:${var.like_service_port_1}"
}

output "like_service_2_url" {
  description = "Direct URL to second LikeService instance"
  value       = "http://localhost:${var.like_service_port_2}"
}

output "docker_network_name" {
  description = "Name of the Docker network"
  value       = docker_network.app_network.name
}
