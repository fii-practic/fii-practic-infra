resource "aws_instance" "ec2_instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip_address
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  disable_api_termination     = var.disable_api_termination

  root_block_device {
    volume_type           = var.volume_type
    delete_on_termination = var.delete_on_termination
    volume_size           = var.volume_size
  }

  tags = var.tags
}

