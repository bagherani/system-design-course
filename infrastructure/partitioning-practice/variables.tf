variable "postgres_version" {
  description = "PostgreSQL Docker image tag"
  type        = string
  default     = "16"
}

variable "host_port" {
  description = "Host port for PostgreSQL"
  type        = number
  default     = 5432
}

variable "postgres_password" {
  description = "Password for the postgres user"
  type        = string
  default     = "postgres"
  sensitive   = true
}

variable "container_name" {
  description = "Name of the PostgreSQL Docker container"
  type        = string
  default     = "pg"
}
