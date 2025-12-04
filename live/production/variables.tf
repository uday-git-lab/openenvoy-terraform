variable "aws_region" {
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  type        = string
  default     = "prod-webapp"
}

variable "vpc_cidr" {
  description = "VPC CIDR for this environment."
  type        = string
}

variable "public_subnets" {
  description = "Public subnet CIDRs and AZs for this environment."
  type = list(object({
    cidr_block        = string
    availability_zone = string
  }))
}

variable "private_subnets" {
  description = "Private subnet CIDRs and AZs for this environment."
  type = list(object({
    cidr_block        = string
    availability_zone = string
  }))
}