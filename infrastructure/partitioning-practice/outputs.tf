output "postgres_host" {
  value       = "localhost"
  description = "Host to connect to PostgreSQL"
}

output "postgres_port" {
  value       = var.host_port
  description = "Port for PostgreSQL"
}

output "demo_database" {
  value       = "demo"
  description = "Name of the demo database with partitioned users table"
}

output "connection_command" {
  value       = "docker exec -it ${docker_container.postgres.name} psql -U postgres -d demo"
  description = "Example command to open psql in the demo database"
}
