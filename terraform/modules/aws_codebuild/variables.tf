variable "name" {}

variable "environment" {}

variable "team_name" {}

variable "codecommit_repo" {}

variable "description" {}

variable "creator" {
  type    = string
  default = "Managed by Terraform"
}