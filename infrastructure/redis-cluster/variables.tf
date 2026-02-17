variable "redis_version" {
  description = "Redis Docker image tag"
  type        = string
  default     = "7-alpine"
}

variable "redis_node1_port" {
  description = "Host port for redis-node-1"
  type        = number
  default     = 6379
}

variable "redis_node2_port" {
  description = "Host port for redis-node-2"
  type        = number
  default     = 6380
}

variable "redis_node3_port" {
  description = "Host port for redis-node-3"
  type        = number
  default     = 6381
}

variable "like_service_with_db_port" {
  description = "Host port for LikeServiceWithDB HTTP"
  type        = number
  default     = 3012
}

variable "like_service_with_db_image_tag" {
  description = "Tag for the LikeServiceWithDB Docker image"
  type        = string
  default     = "1.0.0"
}
