variable "name" {}

variable "environment" {}

variable "team_name" {}

variable "github_repo" {}

variable "description" {}

variable "creator" {
  type    = string
  default = "Managed by Terraform"
}