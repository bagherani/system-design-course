output "redis_cluster_nodes" {
  description = "Redis cluster node addresses (for clients on same Docker network)"
  value       = "redis-node-1:6379,redis-node-2:6379,redis-node-3:6379"
}

output "redis_node1_url" {
  description = "Host URL for redis-node-1 (direct access)"
  value       = "localhost:${var.redis_node1_port}"
}

output "redis_node2_url" {
  description = "Host URL for redis-node-2"
  value       = "localhost:${var.redis_node2_port}"
}

output "redis_node3_url" {
  description = "Host URL for redis-node-3"
  value       = "localhost:${var.redis_node3_port}"
}

output "like_service_with_db_url" {
  description = "URL for LikeServiceWithDB HTTP API"
  value       = "http://localhost:${var.like_service_with_db_port}"
}

output "docker_network_name" {
  description = "Docker network name"
  value       = docker_network.redis.name
}
