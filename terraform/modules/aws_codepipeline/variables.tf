variable "name" {}

variable "team_name" {}

variable "description" {}

variable "environment" {}

variable "cd_app_name" {}

variable "cd_d_grp_name" {}

variable "creator" {
  type    = string
  default = "Managed by Terraform"
}

variable "code_repo_arn" {}