resource "aws_key_pair" "iulian_public_key" {
  key_name   = "${var.account}-iulian-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDPiQjIZ4x3qm2txJGr0DVBu+GGSEGzyHhQRRB42Kf+D2GXypf55JmNlG3a6MXA+rOJ77oxC+1aZI12Mc8uIecUGNkjrqVL2/gZEZmjhE4cVjnMBGFrS2rzigB/jju8X4E0sNDwxFACkf0TspLKdTDU+gkFsAH4fAuooVZkvnx80bFPKthODnD7XKgLvCPhWEOq6fKGLMG4aq4Lf+Sdwh9+IkUKb/DeHRgz5gRyP83bJ/VF59MR5Ayos9PPQkpe7FzjQyoX1nkwXmFb7OTjgVoMzYVD7qht4Z1wk1WQfaKmPKwXOcX/H1FOlA/WI0yrwvaKWnZKXredkaY1LAF9kCZ iulian@fii-practic.fun"

  tags_all = {
    Name        = "${var.account}-${var.env}-iulian-key"
    Environment = var.env
    Creator     = var.creator
  }
}


resource "aws_security_group" "allow_ssh" {
  name        = "${var.account}-${var.env}-allow-ssh-sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = module.vpc.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.account}-${var.env}-allow-ssh-sg"
    Environment = var.env
    Creator     = var.creator
  }
}

module "ec2_instance_local_module" {
  source = "../../modules/aws_ec2"

  name = "${var.account}-${var.env}-instance-local-module"

  ami                    = data.aws_ami.amzn_ami.image_id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.iulian_public_key.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Name        = "${var.account}-${var.env}-instance-local-module"
    Creator     = var.creator
    Environment = var.env
  }
}

module "ec2_instance_public_module" {
  source = "terraform-aws-modules/ec2-instance/aws"
  #version = "4.3.0"
  version = "5.6.0"

  name = "${var.account}-${var.env}-instance-public-module"

  ami                    = data.aws_ami.amzn_ami.image_id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.iulian_public_key.key_name
  monitoring             = false
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Name        = "${var.account}-${var.env}-instance-public-module"
    Creator     = var.creator
    Environment = var.env
  }
}

