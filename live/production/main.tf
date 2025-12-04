terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = "openenvoy-tf-state"
    key            = "openenvoy/infra.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

#########################
# Network (already done)
#########################

module "network" {
  source = "../../modules/aws-network"

  name            = var.project_name
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = true

  tags = {
    Environment = "production"
    Project     = var.project_name
  }
}

#########################
# Security Groups module
#########################

module "security" {
  source = "../../modules/aws-security"

  name   = var.project_name
  vpc_id = module.network.vpc_id

  allowed_http_ingress_cidrs = ["0.0.0.0/0"] # or lock down as needed
  allowed_ssh_ingress_cidrs  = []           # no SSH from internet in prod

  tags = {
    Environment = "production"
    Project     = var.project_name
  }
}

#########################
# Web App module
#########################

locals {
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl enable httpd
    systemctl start httpd
    echo "<h1>${var.project_name} - running on $(hostname -f)</h1>" > /var/www/html/index.html
  EOF
}

module "web_app" {
  source = "../../modules/aws-web-app"

  name       = var.project_name
  vpc_id     = module.network.vpc_id

  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids

  alb_security_group_id = module.security.alb_security_group_id
  app_security_group_id = module.security.app_security_group_id

  instance_type      = "t3.micro"
  desired_capacity   = 2
  min_size           = 2
  max_size           = 4
  user_data_base64   = base64encode(local.user_data)
  health_check_path  = "/"

  tags = {
    Environment = "production"
    Project     = var.project_name
  }
}
