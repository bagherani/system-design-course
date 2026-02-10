output "cql_node1" {
  value = "localhost:${var.cql_port_node1}"
}

output "cql_node2" {
  value = "localhost:${var.cql_port_node2}"
}

output "cql_node3" {
  value = "localhost:${var.cql_port_node3}"
}

output "users_service_url" {
  value = "http://localhost:${var.users_service_port}"
}
