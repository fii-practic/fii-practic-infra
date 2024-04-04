variable "repository_name" {}

variable "description" {
  default = "This is the default description. Because I'm lazy!"
}

variable "tags" {
  default = ""
}

variable "team_name" {
  default = "This is the default team name. Because I'm lazy!"
}

variable "lifecycle_destroy_switch" {
  default = true
  type    = bool
}

variable "creator" {
  type    = string
  default = "Managed by Terraform"
}