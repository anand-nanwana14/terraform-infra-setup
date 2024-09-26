**1. Project’s Title **  

“Terraform Infra Setup”

Seting up a infra using terraform
VPC
3 subnets - private & public
NAT gateway & IGW
NAT instance & Jumpserver
S3 bucket that stores tfstate files

2. **Project Description**
   
Creating a infra for AWS in which we will take internet access in NAT instance using NAT Gateway.

a.VPC Creation: The project starts by creating a Virtual Private Cloud (VPC) on AWS. The VPC provides a logically isolated section of the AWS cloud where you can launch resources.

b.Subnet Configuration: Within the VPC, the project creates both public and private subnets. These subnets are essential for organizing resources and controlling inbound and outbound traffic.

c.Instance Deployment:
Private Instance: A private EC2 instance is deployed within the private subnet. Private instances typically host backend services or databases that don’t require direct access from the internet.
Public Instance (Jump Host): A public EC2 instance, also known as a jump host or bastion host, is deployed within the public subnet. This instance acts as an entry point for accessing private instances securely.

d.Networking Components:
Internet Gateway: An internet gateway is attached to the VPC, enabling communication between instances in the VPC and the internet.
NAT Gateway: A Network Address Translation (NAT) gateway is deployed to allow private instances in the VPC to initiate outbound connections to the internet while preventing inbound traffic from reaching them directly.
Route Tables: Route tables are configured to direct traffic between subnets and internet gateways or NAT gateways appropriately.

e.Networking Components:
Internet Gateway: An internet gateway is attached to the VPC, enabling communication between instances in the VPC and the internet.
NAT Gateway: A Network Address Translation (NAT) gateway is deployed to allow private instances in the VPC to initiate outbound connections to the internet while preventing inbound traffic from reaching them directly.
Route Tables: Route tables are configured to direct traffic between subnets and internet gateways or NAT gateways appropriately.

3.**How to Run the Project**

1.Clone this repo onto your machine.  

2.Change Variables as per your need.  

3.Export Your Access & Secret Keys in your machine.  

4.Use command “terraform init” to initialize.  

5.Use Command “terraform plan” to view changes.  

6.Use Command “terraform apply” to apply changes or to setup your infra.  

