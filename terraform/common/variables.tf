# The account name
variable "account" {
}

variable "env" {
}

variable "vpc_cidr_block" {
}

variable "creator" {
  type    = string
  default = "Managed by Terraform"
}

variable "default_trusted_cidrs" {
  type = list(string)

  default = []
  # Needs to be set in '[env].auto.tfvars' file before using this variable in the respective env
}

# Defaults for each env
variable "account_ids" {
  type = map(any)

  default = {
    dev  = "954976320138"
    prod = "991287142927"
  }
}

variable "subnet_count" {
  default = 3
}

variable "team_tags" {
  type = list(string)
  default = [
    "platform",
    "workplace",
    "support-office",
    "data",
    "customer-service",
    "finance",
    "buying-and-sales",
  ]
}

# Tags for BusinessUnit's
variable "aws_tags_BU_product" {
  default = "product"
}
variable "aws_tags_BU_marketing" {
  default = "marketing"
}
variable "aws_tags_BU_technology" {
  default = "technology"
}

variable "arn_central_backup_account_id" {
  default = "arn:aws:iam::217314892615:root"
}

variable "central_backup_account_name" {
  default = "demo_backup"
}



