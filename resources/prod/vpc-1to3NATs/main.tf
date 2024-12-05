provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source              = "../../../modules/vpc-1to3NATs"
  vpc_cidr            = "10.0.0.0/16"
  num_public_subnets  = 3
  num_private_subnets = 3
  num_nat_gateways    = 3
  tags = {
    "owner"          = "EK TECH SOFTWARE SOLUTION"
    "environment"    = "dev"
    "project"        = "del"
    "created_by"     = "Terraform"
    "cloud_provider" = "aws"
  }
}
  