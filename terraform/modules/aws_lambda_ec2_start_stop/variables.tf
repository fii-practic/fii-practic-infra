
variable "name" {}

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "vpc_id" {}

variable "trusted_cidrs" {
  type    = list(string)
  default = []
}

variable "start_schedule_expression" {
}

variable "stop_schedule_expression" {
}

variable "later_stop_schedule_expression" {
}