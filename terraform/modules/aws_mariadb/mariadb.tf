resource "aws_db_instance" "default" {
  allocated_storage                   = var.storage_size
  max_allocated_storage               = var.max_allocated_storage
  allow_major_version_upgrade         = var.allow_major_version_upgrade
  apply_immediately                   = var.apply_immediately
  auto_minor_version_upgrade          = var.auto_minor_version_upgrade
  availability_zone                   = var.availability_zone
  backup_retention_period             = var.backup_retention_period
  backup_window                       = var.backup_window
  copy_tags_to_snapshot               = true
  db_subnet_group_name                = aws_db_subnet_group.default.name
  engine                              = "mariadb"
  engine_version                      = var.engine_version
  final_snapshot_identifier           = var.final_snapshot_identifier
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  identifier                          = "${var.name}-db"
  instance_class                      = var.instance_class
  license_model                       = "general-public-license"
  maintenance_window                  = var.maintenance_window
  monitoring_interval                 = var.monitoring_interval
  monitoring_role_arn                 = var.monitoring_role_arn
  multi_az                            = var.multi_az
  option_group_name                   = var.option_group_name
  parameter_group_name                = var.parameter_group_name
  username                            = var.username
  password                            = var.password
  publicly_accessible                 = var.publicly_accessible
  skip_final_snapshot                 = var.skip_final_snapshot
  storage_encrypted                   = false
  storage_type                        = var.storage_type
  vpc_security_group_ids              = [aws_security_group.mysql_sg.id]
  deletion_protection                 = true

  tags = {
    Name    = "${var.tag_Name}-db"
    Creator = "Managed by Terraform"
  }

}

resource "aws_db_subnet_group" "default" {
  name       = "${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.identifier}-subnet-group"
  }
}

resource "aws_security_group" "mysql_sg" {
  name        = "${var.identifier}-mysql"
  description = "${var.identifier} MySQL Instances"
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
  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"
  cidr_blocks = var.trusted_cidrs

  security_group_id = aws_security_group.mysql_sg.id
}


resource "aws_route53_record" "mysql" {
  zone_id = var.route53_zone_id
  name    = "${var.name}-db"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_db_instance.default.address]
}
