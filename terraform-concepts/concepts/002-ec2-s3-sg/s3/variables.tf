variable "aws_region" {
    description = "aws region"
    type = string
    default = "us-east-1"
}

variable "aws_s3_bucket" {
    description = "s3 bucket by terraform"
    type        = string
    default     = "terraform-s3-bucket-11"
}

variable "aws_dynamodb_table" {
    description = "DynamoDB table by terraform"
    type        = string
    default     = "a1helene11_terraform_state_lock"
}

variable "tags" {
    description = "Base tags to be applied to all resources"
    type        = map(string)
    default     = {
    "owner"          = "EK TECH SOFTWARE SOLUTION"
    "environment"    = "dev"
    "project"        = "del"
    "create_by"      = "Terraform"
    "cloud_provider" = "aws"
    }
}
  