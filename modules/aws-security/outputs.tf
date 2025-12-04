output "alb_security_group_id" {
  description = "Security group ID used by the public ALB."
  value       = aws_security_group.external_alb.id
}

output "app_security_group_id" {
  description = "Security group ID used by internal app instances."
  value       = aws_security_group.internal_app.id
}