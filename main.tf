# Define AWS provider
provider "aws" {
  region = var.region
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_name
  }
}
data "aws_availability_zones" "available" {}

# Public Subnets
resource "aws_subnet" "public" {
  count             = var.subnet_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  

  tags = {
    Name = "${var.subnet_name_prefix}-public-${count.index}"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = var.subnet_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index + 10)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "${var.subnet_name_prefix}-private-${count.index}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.gateway_name
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.rt-public_cidr_block
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = var.route_table_name
  }
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public" {
  count          = var.subnet_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = var.nat_gateway_name
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {}

# Private Route Tables
resource "aws_route_table" "private" {
  count = var.subnet_count
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.route_table_name}-${count.index}"
  }
}

# Routes for Private Subnets to NAT Gateway
resource "aws_route" "private" {
  count          = var.subnet_count
  route_table_id = aws_route_table.private[count.index].id
  destination_cidr_block = var.rt-private_cidr_block
  nat_gateway_id = aws_nat_gateway.nat.id
}

# Security Group for SSH Access
resource "aws_security_group" "ssh" {
  vpc_id = aws_vpc.main.id
  name   = var.security_group_name

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Public Instances
resource "aws_instance" "public_instance" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public[count.index].id
  security_groups = [aws_security_group.ssh.id]
  key_name      = var.key_name
  associate_public_ip_address = true  

  tags = {
    Name = "${var.instance_name_prefix}-public"
  }
}

# Private Instance
resource "aws_instance" "private_instance" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private[count.index].id
  security_groups = [aws_security_group.ssh.id]
  key_name      = var.key_name

  tags = {
    Name = "${var.instance_name_prefix}-private"
  }
}

output "nat_gateway_ip" {
  value = aws_eip.nat.public_ip
}
