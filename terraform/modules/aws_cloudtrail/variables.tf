variable "account_id" {}

variable "account" {}

variable "region" {
  description = "the AWS region this bucket should reside in."
  default     = "eu-west-1"
}