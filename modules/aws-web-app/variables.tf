variable "name" {
  description = "Base name/prefix for all web app resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the web app components will be created."
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB."
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for ASG instances."
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID for the ALB (external)."
  type        = string
}

variable "app_security_group_id" {
  description = "Security group ID for app instances (internal)."
  type        = string
}

variable "instance_type" {
  description = "Instance type for web instances."
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for web instances. If null, latest Amazon Linux 2 is used."
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "Base64-encoded user data script for instances."
  type        = string
  default     = ""
}

variable "desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group."
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum size of the Auto Scaling Group."
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum size of the Auto Scaling Group."
  type        = number
  default     = 4
}

variable "health_check_path" {
  description = "ALB health check path."
  type        = string
  default     = "/"
}

variable "cpu_target_utilization" {
  description = "Target average CPU utilization percentage for ASG target tracking."
  type        = number
  default     = 60
}

variable "tags" {
  description = "Common tags for all web app resources."
  type        = map(string)
  default     = {}
}
