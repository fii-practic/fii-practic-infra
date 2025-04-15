module "levi9_aio_alb" {
  source      = "../../modules/aws_alb"
  name        = "levi9-aio"
  vpc_id      = module.vpc.id
  subnet_ids  = module.vpc.public_subnets
  zone_id     = aws_route53_zone.main.id
  domain_name = aws_route53_zone.main.name
  cert_arn    = module.acm_wildcard.arn
  environment = var.env
  team_name   = "Levi9-DevOps"
}
