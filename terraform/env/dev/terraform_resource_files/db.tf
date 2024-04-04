# RDS MySQL
module "fii_main_db" {
  source                  = "../../modules/aws_mariadb"
  name                    = "main"
  identifier              = var.account
  subnet_ids              = module.vpc.private_subnets
  engine_version          = "10.4"
  parameter_group_name    = "default.mariadb10.4"
  instance_class          = "db.t4g.micro"
  username                = var.username
  password                = var.password
  vpc_id                  = module.vpc.id
  trusted_cidrs           = var.trusted_cidrs
  backup_retention_period = 35
  skip_final_snapshot     = true
  route53_zone_id         = aws_route53_zone.main.id
  tag_Name                = "main"
}

# Elasticahe Redis
module "fii_main_redis" {
  source               = "../../modules/aws_elasticache_redis"
  name                 = "main"
  cluster_id           = "main"
  engine_version       = "6.x"
  node_type            = "cache.t3.micro"
  subnet_ids           = module.vpc.private_subnets
  parameter_group_name = "default.redis6.x"
  vpc_id               = module.vpc.id
  trusted_cidrs        = var.trusted_cidrs
  route53_zone_id      = aws_route53_zone.main.id
}