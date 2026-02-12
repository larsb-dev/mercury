variable "project_name" {
  type    = string
  default = "mercury"
}

variable "location" {
  type    = string
  default = "Switzerland North"
}

variable "image_tag" {
  description = "Docker image tag"
  type        = string
  default     = "latest"
}
