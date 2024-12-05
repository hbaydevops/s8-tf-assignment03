variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Defines the IP address range for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "num_nat_gateways" {
  description = "The number of NAT Gateways to create. Valid values are 1, 2, or 3."
  type        = number
  default     = 1
}

variable "num_public_subnets" {
  description = "The number of public subnets to create. Valid values are 1, 2, or 3."
  type        = number
  default     = 2
}

variable "num_private_subnets" {
  description = "The number of private subnets to create. Valid values are 1, 2, or 3."
  type        = number
  default     = 2
}

variable "tags" {
  description = "Base tags to be applied to all resources. Ensures consistent tagging across AWS resources."
  type        = map(string)
  default     = {
    "owner"          = "EK TECH SOFTWARE SOLUTION"
    "environment"    = "dev"
    "project"        = "del"
    "create_by"      = "Terraform"
    "cloud_provider" = "aws"
  }
}

provider "aws" {
  profile = "awsbayombi"
  region  = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(var.tags, { "Name" = "Main VPC" })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { "Name" = "Internet Gateway" })
}

resource "aws_subnet" "public" {
  count = var.num_public_subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  map_public_ip_on_launch = true

  tags = merge(var.tags, { "Name" = "Public Subnet ${count.index + 1}" })
}

resource "aws_subnet" "private" {
  count = var.num_private_subnets

  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, var.num_public_subnets + count.index)

  tags = merge(var.tags, { "Name" = "Private Subnet ${count.index + 1}" })
}

resource "aws_nat_gateway" "nat" {
  count                   = var.num_nat_gateways
  allocation_id           = aws_eip.nat[count.index].id
  subnet_id               = element(aws_subnet.public[*].id, count.index % var.num_public_subnets)
  tags                    = merge(var.tags, { "Name" = "NAT Gateway ${count.index + 1}" })
}

resource "aws_eip" "nat" {
  count = var.num_nat_gateways
  vpc   = true
  tags  = merge(var.tags, { "Name" = "Elastic IP for NAT Gateway ${count.index + 1}" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { "Name" = "Public Route Table" })

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  count     = var.num_public_subnets
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count  = var.num_nat_gateways
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { "Name" = "Private Route Table ${count.index + 1}" })

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }
}

resource "aws_route_table_association" "private" {
  count     = var.num_private_subnets
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = element(aws_route_table.private[*].id, count.index % var.num_nat_gateways)
}

resource "aws_network_acl" "nacl" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { "Name" = "Default NACL" })
}

resource "aws_network_acl_rule" "allow_all_inbound" {
  network_acl_id = aws_network_acl.nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}

resource "aws_network_acl_rule" "allow_all_outbound" {
  network_acl_id = aws_network_acl.nacl.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
}
