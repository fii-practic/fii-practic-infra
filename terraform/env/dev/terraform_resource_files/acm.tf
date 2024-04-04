# SSL/TLS Certificate Manager:
module "acm_wildcard" {
  source      = "../../modules/aws_acm"
  domain_name = "*.${aws_route53_zone.main.name}"
  zone_id     = aws_route53_zone.main.id
  environment = var.env
  team_name   = "Levi9-DevOps"
}
