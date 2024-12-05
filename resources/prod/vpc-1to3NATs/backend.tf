
terraform {
  backend "s3" {
    bucket         = "terraform-s3-bucket-10"
    key            = "vpc/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "a1helene_terraform_state_lock"
    encrypt        = true
  }
}

  