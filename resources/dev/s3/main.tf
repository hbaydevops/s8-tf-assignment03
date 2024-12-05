
provider "aws" {
    region = var.aws_region
  }

module "s3" {

    source = "../../../module002/s3"
    aws_region = "us-east-1"
    aws_s3_bucket = "terraform-s3-bucket-11"
    aws_dynamodb_table = "a1helene11_terraform_state_lock"
    tags = {
        "owner"          = "EK TECH SOFTWARE SOLUTION"
        "environment"    = "dev"
        "project"        = "del"
        "create_by"      = "Terraform"
        "cloud_provider" = "aws"
            
    }
}







