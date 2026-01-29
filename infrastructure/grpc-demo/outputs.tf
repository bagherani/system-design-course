output "feed_service_url" {
  description = "URL for FeedService (calls EngagementService via gRPC)"
  value       = "http://localhost:${var.feed_service_port}"
}

output "engagement_http_url" {
  description = "URL for EngagementService HTTP"
  value       = "http://localhost:${var.engagement_http_port}"
}

output "engagement_grpc_address" {
  description = "gRPC address for EngagementService (from host)"
  value       = "localhost:${var.engagement_grpc_port}"
}

output "docker_network_name" {
  description = "Name of the Docker network"
  value       = docker_network.grpc_network.name
}
