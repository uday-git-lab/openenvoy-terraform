output "vpc_id" {
  description = "VPC ID from the network module."
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs from the network module."
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs from the network module."
  value       = module.network.private_subnet_ids
}

output "alb_dns_name" {
  description = "Public DNS name of the web application ALB."
  value       = module.web_app.alb_dns_name
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group."
  value       = module.web_app.autoscaling_group_name
}
