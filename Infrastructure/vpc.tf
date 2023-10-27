# Using opensource TF module for AWS VPC Setup

module "demo_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"
  name                   = var.app_name
  cidr                   = var.cidr
  private_subnets        = var.private_subnets
  public_subnets         = var.public_subnets
  single_nat_gateway     = true
  enable_nat_gateway     = true
  one_nat_gateway_per_az = false
  tags                   = local.tags
}