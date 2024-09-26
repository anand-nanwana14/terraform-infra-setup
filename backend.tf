terraform {
  backend "s3" {
    bucket         = "demo-terraform-bucket-practise1"
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}
