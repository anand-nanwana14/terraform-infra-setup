provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    "Name" = "terraform"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "instance" {
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "teraformSubnetInstance"
  }
}

resource "aws_security_group" "securitygroup" {
  name = "terraformSecurityGroup"
  description = "terraformSecurityGroup"
  vpc_id = aws_vpc.vpc.id
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  tags = {
    "Name" = "terraformSecurityGroup"
  }
}

resource "aws_instance" "terraforminstance" {
  instance_type = "t2.micro"
  ami = "ami-080e1f13689e07408"
  subnet_id = aws_subnet.instance.id
  security_groups = [aws_security_group.securitygroup.id]
  key_name = "jenkins"
  tags = {
    "Name" = "terraformMachine"
  }
}

resource "aws_subnet" "nat_gateway" {
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block = "10.0.2.0/24"
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "terraformSubnetNAT"
  }
}

resource "aws_internet_gateway" "nat_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "terraformGateway"
  }
}

resource "aws_route_table" "nat_gateway" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nat_gateway.id
  }
}

resource "aws_route_table_association" "nat_gateway" {
  subnet_id = aws_subnet.nat_gateway.id
  route_table_id = aws_route_table.nat_gateway.id
}

resource "aws_eip" "nat_gateway" {
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id = aws_subnet.nat_gateway.id
  tags = {
    "Name" = "terraformNatGateway"
  }
}

output "nat_gateway_ip" {
  value = aws_eip.nat_gateway.public_ip
}

resource "aws_route_table" "instance" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}

resource "aws_route_table_association" "instance" {
  subnet_id = aws_subnet.instance.id
  route_table_id = aws_route_table.instance.id
}

resource "aws_instance" "ec2jumphost" {
  instance_type = "t2.micro"
  ami = "ami-080e1f13689e07408" 
  subnet_id = aws_subnet.nat_gateway.id
  security_groups = [aws_security_group.securitygroup.id]
  key_name = "jenkins"
  tags = {
    "Name" = "terraformMachineJumphost"
  }
}

resource "aws_eip" "jumphost" {
  instance = aws_instance.ec2jumphost.id
}

