resource "aws_elasticache_cluster" "elasticache_redis" {
  cluster_id           = var.cluster_id
  engine               = "redis"
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  engine_version       = var.engine_version
  maintenance_window   = var.maintenance_window
  parameter_group_name = var.parameter_group_name
  port                 = var.port
  subnet_group_name    = aws_elasticache_subnet_group.default.name
  security_group_ids   = [aws_security_group.redis_sg.id]
  tags = {
    Creator = "Managed by Terraform"
  }
}

resource "aws_elasticache_subnet_group" "default" {
  name        = "${var.cluster_id}-subnet-group"
  subnet_ids  = var.subnet_ids
  description = "${var.cluster_id} Elasticache Redis subnet group"
}

resource "aws_security_group" "redis_sg" {
  name        = "${var.cluster_id}-redis-subnet-group"
  description = "${var.cluster_id} Elasticache Redis Instances security group"
  vpc_id      = var.vpc_id

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_inbound" {
  type        = "ingress"
  from_port   = 6379
  to_port     = 6379
  protocol    = "tcp"
  cidr_blocks = var.trusted_cidrs

  security_group_id = aws_security_group.redis_sg.id
}

resource "aws_security_group_rule" "allow_inbound_sg" {
  count                    = length(var.trusted_security_groups)
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = var.trusted_security_groups[count.index]
  security_group_id        = aws_security_group.redis_sg.id
}

resource "aws_route53_record" "www" {
  zone_id = var.route53_zone_id
  name    = "${var.name}-redis"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_elasticache_cluster.elasticache_redis.cache_nodes[0].address]
}

