variable "name" {}

variable "team_name" {}

variable "environment" {}

variable "tpl_name" {}

variable "docker_image" {}

variable "ecs_cluster_id" {}

variable "target_group_arn" {}

variable "subnets" {}

variable "region" {}

variable "vpc_id" {}

variable "creator" {
  type    = string
  default = "Managed by Terraform"
}