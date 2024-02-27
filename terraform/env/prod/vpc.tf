# #Make DNS for the VPC - environmet in Route53
# resource "aws_route53_zone" "main" {
#   name = "${var.account}.fun."
# }

#Building basic vpc
# module "vpc" {
#   source           = "../../modules/aws_vpc"
#   name             = var.account
#   private_key_path = var.private_key_path
#   cidr_block       = var.vpc_cidr_block
#   trusted_cidrs    = var.trusted_cidrs
#   route53_zone_id  = aws_route53_zone.main.id
# }

