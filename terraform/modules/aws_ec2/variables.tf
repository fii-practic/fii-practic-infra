variable "name" {}

variable "ami" {}

variable "instance_type" {}

variable "key_name" {}

variable "subnet_id" {}

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

variable "vpc_security_group_ids" {
  type    = list(string)
  default = []
}

variable "tags" {}