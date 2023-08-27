variable "name" {
  description = "bucket name (required)"
  type        = string
}
variable "ip_cidr_range" {
  type = any
}

variable "region" {
  type = string
}
variable "network_id" {
  type = any
}
