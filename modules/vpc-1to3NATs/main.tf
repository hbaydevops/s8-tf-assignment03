resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(var.tags, { Name = "tf-main-vpc" })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "tf-main-igw" })
}

resource "aws_subnet" "public" {
  count = var.num_public_subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  map_public_ip_on_launch = true

  tags = merge(var.tags, { "Name" = "tf-public-subnet-${count.index + 1}" })
}

resource "aws_subnet" "private" {
  count = var.num_private_subnets

  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, var.num_public_subnets + count.index)

  tags = merge(var.tags, { "Name" = "tf-private-subnet ${count.index + 1}" })
}

resource "aws_nat_gateway" "nat" {
  count         = var.num_nat_gateways
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = element(aws_subnet.public[*].id, count.index % var.num_public_subnets)
  tags          = var.tags
}

resource "aws_eip" "nat" {
  count = var.num_nat_gateways
  vpc   = true
  tags  = var.tags
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags   = var.tags

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  count          = var.num_public_subnets
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count  = var.num_nat_gateways
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { "Name" = "tf-private-route-table-${count.index + 1}" })

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }
}

resource "aws_route_table_association" "private" {
  count          = var.num_private_subnets
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = element(aws_route_table.private[*].id, count.index % var.num_nat_gateways)
}

resource "aws_network_acl" "nacl" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { "Name" = "tf-main-nacl" })
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


