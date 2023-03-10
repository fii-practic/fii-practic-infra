# Defaults for each env

variable "vpc_cidr_block" {
  default = "10.10.0.0/16"
}

# variable "role_arns" {
#   type = map

#   default = {
#     fii-practic = "arn:aws:iam::617129651895:role/Administrator"
#   }
# }

# variable "account_ids" {
#   type = map

#   default = {
#     fii-practic = "617129651895"
#   }
# }

variable "private_key_path" {
  type = string
  default = "/home/iulian/.ssh/ic_id_rsa"
}

variable "authorized_keys" {
  type = list

  default = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDACOzQhji5kIkUPtjMO/tyPPYiVMz+JvvDJX56oY/rwrzydv2aVDyOM6EQcTnlNRnOT5bA7Ml2Vb5EVLgXs3c6tY8cMrDD1qmiN4cA1umHAs3prx3PpfVRcZ7QCvudNkBP0osovkT3QzFhcikboAeTVNhDg53C96h+g9vSxh5+pYHqKEYrZ+46hEXdTOZHLiWbtNy1iM/TEMdiuNt2SPrmaHRuzVHrKI+Lldee0t7B3ZEyd1Kzt/ueHc6lUmk7k069TdqENvN5dJLH2cfScpWoflJervSmJmQd7KOD/NEL5qCx/Bns5qKDzjvxW7EuRS1+9nsHDZ7eG60dVO8zKyEj iconstantinescu@jxeelab.com",
  ]
}

# The account name
variable "account" {}

variable "environment" {
  default = "dev"
}

variable "subnet_count" {
  default = 3
}

variable "trusted_cidrs" {
  type = list

  default = [
    "10.10.0.0/24",
    "10.10.1.0/24",
    "10.10.2.0/24",
    "10.10.4.0/24",
    "10.10.5.0/24",
    "10.10.6.0/24",
    ]
}

#variable "username" {
#  sensitive = true
#}

#variable "password" {
#  sensitive = true
#}
