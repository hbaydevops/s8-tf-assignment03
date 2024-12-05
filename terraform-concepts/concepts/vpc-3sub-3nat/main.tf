# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(var.tags, { Name = "tf-main-vpc" })
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "tf-main-igw" })
}

# Public Subnets
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags                    = merge(var.tags, { Name = "tf-public-subnet-1" })
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags                    = merge(var.tags, { Name = "tf-public-subnet-2" })
}

resource "aws_subnet" "public_3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1c"
  tags                    = merge(var.tags, { Name = "tf-public-subnet-3" })
}

# Private Subnets
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1a"
  tags              = merge(var.tags, { Name = "tf-private-subnet-1" })
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1b"
  tags              = merge(var.tags, { Name = "tf-private-subnet-2" })
}

resource "aws_subnet" "private_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-east-1c"
  tags              = merge(var.tags, { Name = "tf-private-subnet-3" })
}

# NAT Gateways and Elastic IPs
resource "aws_eip" "nat_1" {
  vpc  = true
  tags = merge(var.tags, { Name = "tf-nat-eip-1" })
}

resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.nat_1.id
  subnet_id     = aws_subnet.public_1.id
  tags          = merge(var.tags, { Name = "tf-nat-gateway-1" })
}

resource "aws_eip" "nat_2" {
  vpc  = true
  tags = merge(var.tags, { Name = "tf-nat-eip-2" })
}

resource "aws_nat_gateway" "nat_2" {
  allocation_id = aws_eip.nat_2.id
  subnet_id     = aws_subnet.public_2.id
  tags          = merge(var.tags, { Name = "tf-nat-gateway-2" })
}

resource "aws_eip" "nat_3" {
  vpc  = true
  tags = merge(var.tags, { Name = "tf-nat-eip-3" })
}

resource "aws_nat_gateway" "nat_3" {
  allocation_id = aws_eip.nat_3.id
  subnet_id     = aws_subnet.public_3.id
  tags          = merge(var.tags, { Name = "tf-nat-gateway-3" })
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "tf-public-route-table" })
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_association_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_association_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_association_3" {
  subnet_id      = aws_subnet.public_3.id
  route_table_id = aws_route_table.public.id
}

# Private Route Tables
resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "tf-private-route-table-1" })
}

resource "aws_route" "private_route_1" {
  route_table_id         = aws_route_table.private_1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_1.id
}

resource "aws_route_table_association" "private_association_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_1.id
}

resource "aws_route_table" "private_2" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "tf-private-route-table-2" })
}

resource "aws_route" "private_route_2" {
  route_table_id         = aws_route_table.private_2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_2.id
}

resource "aws_route_table_association" "private_association_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_2.id
}

resource "aws_route_table" "private_3" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "tf-private-route-table-3" })
}

resource "aws_route" "private_route_3" {
  route_table_id         = aws_route_table.private_3.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_3.id
}

resource "aws_route_table_association" "private_association_3" {
  subnet_id      = aws_subnet.private_3.id
  route_table_id = aws_route_table.private_3.id
}

# Public NACL
resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "tf-public-nacl" })
}

# Public NACL Rules
resource "aws_network_acl_rule" "allow_http" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "6" # TCP
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "allow_https" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 101
  egress         = false
  protocol       = "6" # TCP
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "allow_egress" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 102
  egress         = true
  protocol       = "-1" # All protocols
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

# Associate Public NACL with Public Subnets
resource "aws_network_acl_association" "public_1_association" {
  subnet_id      = aws_subnet.public_1.id
  network_acl_id = aws_network_acl.public_nacl.id
}

resource "aws_network_acl_association" "public_2_association" {
  subnet_id      = aws_subnet.public_2.id
  network_acl_id = aws_network_acl.public_nacl.id
}

resource "aws_network_acl_association" "public_3_association" {
  subnet_id      = aws_subnet.public_3.id
  network_acl_id = aws_network_acl.public_nacl.id
}

# Private NACL
resource "aws_network_acl" "private_nacl" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "tf-private-nacl" })
}

# Private NACL Rules
resource "aws_network_acl_rule" "allow_internal" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "-1" # All protocols
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/16" # Internal traffic within the VPC
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "allow_egress_private" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 101
  egress         = true
  protocol       = "-1" # All protocols
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

# Associate Private NACL with Private Subnets
resource "aws_network_acl_association" "private_1_association" {
  subnet_id      = aws_subnet.private_1.id
  network_acl_id = aws_network_acl.private_nacl.id
}

resource "aws_network_acl_association" "private_2_association" {
  subnet_id      = aws_subnet.private_2.id
  network_acl_id = aws_network_acl.private_nacl.id
}

resource "aws_network_acl_association" "private_3_association" {
  subnet_id      = aws_subnet.private_3.id
  network_acl_id = aws_network_acl.private_nacl.id
}
