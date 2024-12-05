provider "aws" {
  region = var.aws_region
}

module "ec2" {
  source     = "../../../module002/ec2"
  aws_region = "us-east-1"
  key_name = "terraform-assignments-key"
  instance_name = "terraform-Jenkins-master"
  instance_type    = "t2.micro"
  root_volume = 10
  
  tags = {
    "owner"          = "EK TECH SOFTWARE SOLUTION"
    "environment"    = "dev"
    "project"        = "del"
    "create_by"      = "Terraform"
    "cloud_provider" = "aws"
  }

}

