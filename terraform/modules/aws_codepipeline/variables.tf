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

variable "github_owner" {
  type        = string
  description = "GitHub repository owner"
}

variable "github_repo" {
  type        = string
  description = "GitHub repository name"
}

variable "github_branch" {
  type        = string
  description = "GitHub branch name"
  default     = "main"
}

variable "codestar_connection_name" {
  type        = string
  description = "Name for the AWS CodeStar connection to GitHub"
}

variable "account_id" {
  type = string
}



