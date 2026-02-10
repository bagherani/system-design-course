variable "cluster_name" {
  description = "Name of the Cassandra cluster"
  type        = string
  default     = "DemoCluster"
}

variable "cassandra_version" {
  description = "Apache Cassandra Docker image tag"
  type        = string
  default     = "4.1"
}

variable "cql_port_node1" {
  description = "Host port for CQL on cassandra-node-1"
  type        = number
  default     = 9042
}

variable "cql_port_node2" {
  description = "Host port for CQL on cassandra-node-2"
  type        = number
  default     = 9043
}

variable "cql_port_node3" {
  description = "Host port for CQL on cassandra-node-3"
  type        = number
  default     = 9044
}

variable "users_service_port" {
  description = "Host port for UsersService HTTP"
  type        = number
  default     = 3005
}

variable "users_service_image_tag" {
  description = "Tag for the UsersService Docker image"
  type        = string
  default     = "1.0.0"
}

variable "cassandra_max_heap_size" {
  description = "Cassandra JVM max heap size (for Docker resource limits)"
  type        = string
  default     = "512M"
}

variable "cassandra_heap_newsize" {
  description = "Cassandra JVM heap newsize"
  type        = string
  default     = "128M"
}
