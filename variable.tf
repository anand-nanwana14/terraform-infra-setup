variable "region" {
  description = "AWS region"
  default = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name for VPC"
  default     = "terraform-vpc"
}

variable "subnet_count" {
  description = "Number of subnets (public and private)"
  default     = 3
}

variable "subnet_name_prefix" {
  description = "Prefix for subnet names"
  default     = "terraform"
}

variable "gateway_name" {
  description = "Name for Internet Gateway"
  default     = "terraform-igw"
}

variable "route_table_name" {
  description = "Name for Public Route Table"
  default     = "terraform-public-route-table"
}

variable "nat_gateway_name" {
  description = "Name for NAT Gateway"
  default     = "terraform-nat"
}

variable "security_group_name" {
  description = "Name for Security Group"
  default     = "terraform-ssh"
}

variable "instance_count" {
  description = "Number of instances (public and private)"
  default     = 1
}

variable "instance_name_prefix" {
  description = "Prefix for instance names"
  default     = "terraform"
}

variable "ami_id" {
  description = "AMI ID for instances"
  default     = "ami-080e1f13689e07408"
}

variable "instance_type" {
  description = "Instance type"
  default     = "t2.micro"
}

variable "key_name" {
    description = "Key_pair_name"
    default = "jenkins"
}
