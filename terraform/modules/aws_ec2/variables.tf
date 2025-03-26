variable "name" {}

variable "ami" {}

variable "instance_type" {}

variable "key_name" {}

variable "vpc_id" {}

variable "subnet_id" {}

variable "env" {}

variable "account" {}

variable "creator" {}

variable "volume_type" {
  default = "gp3"
}

variable "delete_on_termination" {
  default = true
}

variable "volume_size" {
  default = 8
}

variable "associate_public_ip_address" {
  default = true
}

variable "associate_eip_address" {
  default = 0
}


variable "disable_api_termination" {
  default = true
}

variable "route53_zone_id" {}