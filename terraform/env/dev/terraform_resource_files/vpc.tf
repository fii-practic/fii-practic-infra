# #Make DNS for the VPC - environmet in Route53
resource "aws_route53_zone" "main" {
  name = "${var.account}.it."
}

##Building basic vpc
module "vpc" {
  source     = "../../modules/aws_vpc"
  name       = var.account
  env        = var.env
  cidr_block = var.vpc_cidr_block
}

