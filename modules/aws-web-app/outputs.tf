output "alb_dns_name" {
  description = "DNS name of the public ALB."
  value       = aws_lb.this.dns_name
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group."
  value       = aws_autoscaling_group.this.name
}