# External Security Group: for ALB (public-facing)
resource "aws_security_group" "external_alb" {
  name        = "${var.name}-alb-sg"
  description = "External security group for public ALB"
  vpc_id      = var.vpc_id

  # HTTP from internet (or restricted CIDRs)
  ingress {
    description = "HTTP from allowed CIDRs"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_ingress_cidrs
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-alb-sg"
    Type = "external"
  })
}

# Internal Security Group: for ASG instances (private subnets)
resource "aws_security_group" "internal_app" {
  name        = "${var.name}-app-sg"
  description = "Internal security group for app instances"
  vpc_id      = var.vpc_id

  # HTTP only from ALB SG
  ingress {
    description     = "HTTP from ALB only"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.external_alb.id]
  }

  # Optional SSH from restricted CIDRs
  dynamic "ingress" {
    for_each = length(var.allowed_ssh_ingress_cidrs) > 0 ? [1] : []
    content {
      description = "SSH from allowed CIDRs"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.allowed_ssh_ingress_cidrs
    }
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-app-sg"
    Type = "internal"
  })
}