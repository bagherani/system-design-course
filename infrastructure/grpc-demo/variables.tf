variable "feed_service_image_tag" {
  description = "Tag for the FeedService Docker image"
  type        = string
  default     = "1.0.0"
}

variable "engagement_service_image_tag" {
  description = "Tag for the EngagementService Docker image"
  type        = string
  default     = "1.0.0"
}

variable "feed_service_port" {
  description = "External port for FeedService HTTP"
  type        = number
  default     = 3003
}

variable "engagement_http_port" {
  description = "External port for EngagementService HTTP"
  type        = number
  default     = 3004
}

variable "engagement_grpc_port" {
  description = "External port for EngagementService gRPC (must match internal 50051 for host access)"
  type        = number
  default     = 50051
}
