locals {
  ami_id = var.ami_id != null ? var.ami_id : data.aws_ami.amazon_linux2.id
}

data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

##############################
# Target Group
##############################

resource "aws_lb_target_group" "this" {
  name     = substr("${var.name}-tg", 0, 32)
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    path                = var.health_check_path
    matcher             = "200-399"
  }

  tags = merge(var.tags, {
    Name = "${var.name}-tg"
  })
}

##############################
# Application Load Balancer
##############################

resource "aws_lb" "this" {
  name               = substr("${var.name}-alb", 0, 32)
  load_balancer_type = "application"
  internal           = false
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids

  tags = merge(var.tags, {
    Name = "${var.name}-alb"
  })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

##############################
# Launch Template (private instances)
##############################

resource "aws_launch_template" "this" {
  name_prefix   = "${var.name}-lt-"
  image_id      = local.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.app_security_group_id]

  user_data = var.user_data_base64

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.tags, {
      Name = "${var.name}-web"
    })
  }

  lifecycle {
    create_before_destroy = true
  }
}

##############################
# Auto Scaling Group
##############################

resource "aws_autoscaling_group" "this" {
  name                      = "${var.name}-asg"
  vpc_zone_identifier       = var.private_subnet_ids  # PRIVATE subnets only
  desired_capacity          = var.desired_capacity
  min_size                  = var.min_size
  max_size                  = var.max_size
  health_check_type         = "ELB"
  health_check_grace_period = 60

  target_group_arns = [aws_lb_target_group.this.arn]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.name}-web"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

##############################
# Target Tracking Policy
##############################

resource "aws_autoscaling_policy" "cpu_target" {
  name                   = "${var.name}-cpu-target"
  autoscaling_group_name = aws_autoscaling_group.this.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.cpu_target_utilization
  }
}
