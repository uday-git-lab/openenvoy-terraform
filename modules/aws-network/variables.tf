variable "name" {
  description = "Base name/prefix for all network resources."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnets" {
  description = "List of public subnets with explicit CIDRs and AZs."
  type = list(object({
    cidr_block        = string
    availability_zone = string
  }))
}

variable "private_subnets" {
  description = "List of private subnets with explicit CIDRs and AZs."
  type = list(object({
    cidr_block        = string
    availability_zone = string
  }))
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT Gateways (one per AZ)."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags to apply to all resources."
  type        = map(string)
  default     = {}
}
