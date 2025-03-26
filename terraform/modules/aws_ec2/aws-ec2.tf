resource "aws_instance" "main_ec2_instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip_address
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = aws_security_group.allow_ssh.*.id
  disable_api_termination     = var.disable_api_termination

  root_block_device {
    volume_type           = var.volume_type
    delete_on_termination = var.delete_on_termination
    volume_size           = var.volume_size
  }

  user_data = <<-EOF
            #!/bin/bash
            yum update -y
            yum install nginx -y
            systemctl enable nginx
            systemctl start nginx
            EOF

  tags = {
    Name        = "${var.name}-${var.account}-${var.env}"
    Creator     = var.creator
    Environment = var.env
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "${var.name}-${var.account}-${var.env}-allow-ssh-sg"
  description = "${var.name} allow SSH inbound traffic to EC2 Instance"
  vpc_id      = var.vpc_id

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
    Name        = "${var.name}-${var.account}-${var.env}-allow-ssh-sg"
    Creator     = var.creator
    Environment = var.env
  }
}

resource "aws_route53_record" "default_dns_record" {
  zone_id = var.route53_zone_id
  name    = var.name
  type    = "CNAME"
  ttl     = "300"
  records = [aws_instance.main_ec2_instance.public_ip]
}
