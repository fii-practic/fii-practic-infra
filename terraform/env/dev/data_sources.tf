data "aws_availability_zones" "available" {}

data "aws_region" "current" {}

data "aws_ami" "amzn_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]
}
