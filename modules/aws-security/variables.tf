variable "name" {
  description = "Base name/prefix for all security group resources."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where security groups will be created."
  type        = string
}

variable "allowed_http_ingress_cidrs" {
  description = "CIDRs allowed to access ALB over HTTP (port 80)."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_ssh_ingress_cidrs" {
  description = "CIDRs allowed to SSH into app instances. Empty list disables SSH."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Common tags to apply to all security group resources."
  type        = map(string)
  default     = {}
}