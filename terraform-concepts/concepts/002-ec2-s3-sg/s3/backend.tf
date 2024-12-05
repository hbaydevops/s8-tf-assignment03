
terraform {
  backend "s3" {
    bucket         = var.aws_s3_bucket
    key            = "s3/terraform.tfstate"
    region         = var.aws_region
    dynamodb_table = var.aws_dynamodb_table
    encrypt        = true
  }
}

  