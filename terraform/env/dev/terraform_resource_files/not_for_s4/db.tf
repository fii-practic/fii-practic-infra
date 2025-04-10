# RDS MySQL
module "fii_main_db" {
  source                  = "../../modules/aws_mariadb"
  name                    = "demo-sql"
  env                     = var.env
  identifier              = var.account
  subnet_ids              = module.vpc.private_subnets
  engine_version          = "11.4.5"
  parameter_group_name    = "default.mariadb11.4"
  instance_class          = "db.t4g.micro"
  username                = "rds_user"
  password                = "rds_password_2025"
  vpc_id                  = module.vpc.id
  trusted_cidrs           = [var.vpc_cidr_block]
  backup_retention_period = 35
  skip_final_snapshot     = true
  route53_zone_id         = aws_route53_zone.main.id
}

# Elasticahe Redis
module "fii_main_redis" {
  source               = "../../modules/aws_elasticache_redis"
  name                 = "demo-no-sql"
  cluster_id           = "demo-no-sql"
  engine_version       = "7.1"
  node_type            = "cache.t3.micro"
  subnet_ids           = module.vpc.private_subnets
  parameter_group_name = "default.redis7"
  vpc_id               = module.vpc.id
  trusted_cidrs        = [var.vpc_cidr_block]
  route53_zone_id      = aws_route53_zone.main.id
}