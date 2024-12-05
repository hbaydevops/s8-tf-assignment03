
resource "aws_s3_bucket" "terraform_s3_bucket_11" {
  bucket = var.aws_s3_bucket


  # variable "tags" {
  #   description = "Base tags to be applied to all resources"
  #   type        = map(string)
  #   default     = {
  #   "owner"          = var.tags["owner"]
  #   "environment"    = var.tags["environment"]
  #   "project"        = var.tags["project"]
  #   "create_by"      = var.tags["create_by"]
  #   "cloud_provider" = var.tags["cloud_provider"]
  #   }
  # }

  tags = merge(
    var.tags,
    { Name = format("%s-%s-${var.aws_s3_bucket}", var.tags["environment"], var.tags["project"]) }  
  )
}


resource "aws_dynamodb_table" "a1helene11_terraform_state_lock" {
  name         = var.aws_dynamodb_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
  
  tags = merge(
    var.tags,
    { Name = format("%s-%s-${var.aws_dynamodb_table}", var.tags["environment"], var.tags["project"]) }  
  )
}
  