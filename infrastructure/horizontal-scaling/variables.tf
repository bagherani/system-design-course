variable "like_service_image_tag" {
  description = "Tag for the LikeService Docker image"
  type        = string
  default     = "1.0.0"
}

variable "nginx_port" {
  description = "External port for nginx load balancer"
  type        = number
  default     = 3003
}

variable "like_service_port_1" {
  description = "External port for first LikeService instance"
  type        = number
  default     = 3001
}

variable "like_service_port_2" {
  description = "External port for second LikeService instance"
  type        = number
  default     = 3002
}
