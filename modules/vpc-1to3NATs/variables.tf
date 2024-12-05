variable "tags" {
  description = "Base tags to be applied to all resources"
  type        = map(string)
  default = {
    "owner"          = "EK TECH SOFTWARE SOLUTION"
    "environment"    = "dev"
    "project"        = "del"
    "create_by"      = "Terraform"
    "cloud_provider" = "aws"
  }
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Defines the IP address range for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "num_nat_gateways" {
  description = "The number of NAT Gateways to create. Valid values are 1, 2, or 3."
  type        = number
  default     = 3
}

variable "num_public_subnets" {
  description = "The number of public subnets to create. Valid values are 1, 2, or 3."
  type        = number
  default     = 3
}

variable "num_private_subnets" {
  description = "The number of private subnets to create. Valid values are 1, 2, or 3."
  type        = number
  default     = 3
}

# variable "aws_s3_bucket" {
#   description = "s3 bucket by terraform"
#   type        = string
#   default     = "terraform-s3-bucket-10"
# }

# variable "aws_dynamodb_table" {
#   description = "DynamoDB table by terraform"
#   type        = string
#   default     = "a1helene_terraform_state_lock"
# }

# variable "backend_key" {
#     description = "DynamoDB table by terraform"
#     type        = string
#     default     = "vpc"
# }