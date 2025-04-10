resource "aws_key_pair" "iulian_public_key" {
  key_name   = "${var.account}-iulian-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDACOzQhji5kIkUPtjMO/tyPPYiVMz+JvvDJX56oY/rwrzydv2aVDyOM6EQcTnlNRnOT5bA7Ml2Vb5EVLgXs3c6tY8cMrDD1qmiN4cA1umHAs3prx3PpfVRcZ7QCvudNkBP0osovkT3QzFhcikboAeTVNhDg53C96h+g9vSxh5+pYHqKEYrZ+46hEXdTOZHLiWbtNy1iM/TEMdiuNt2SPrmaHRuzVHrKI+Lldee0t7B3ZEyd1Kzt/ueHc6lUmk7k069TdqENvN5dJLH2cfScpWoflJervSmJmQd7KOD/NEL5qCx/Bns5qKDzjvxW7EuRS1+9nsHDZ7eG60dVO8zKyEj iulian@x1"
  tags_all = {
    Name        = "${var.account}-${var.env}-iulian-key"
    Environment = var.env
    Creator     = var.creator
  }
}

module "ec2_instance_local_module" {
  source = "../../modules/aws_ec2"

  name = "ec2-demo-diy-module"

  ami             = data.aws_ami.amzn_ami.image_id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.iulian_public_key.key_name
  vpc_id          = module.vpc.id
  subnet_id       = module.vpc.public_subnets[0]
  env             = var.env
  account         = var.account
  creator         = var.creator
  route53_zone_id = aws_route53_zone.main.id
}

module "ec2_instance_public_module" {
  source = "terraform-aws-modules/ec2-instance/aws"
  #version = "4.3.0"
  #version = "5.6.0"
  version = "5.7.1"

  name = "ec2-demo-pub-module-${var.account}-${var.env}"

  ami                    = data.aws_ami.amzn_ami.image_id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.iulian_public_key.key_name
  monitoring             = false
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  subnet_id              = module.vpc.public_subnets[0]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install nginx -y
              systemctl enable nginx
              systemctl start nginx
              EOF

  tags = {
    Name        = "ec2-demo-pub-module-${var.account}-${var.env}"
    Creator     = var.creator
    Environment = var.env
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "${var.account}-${var.env}-allow-ssh-sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = module.vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
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
