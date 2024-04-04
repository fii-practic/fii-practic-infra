variable "cidr_block" {
}

variable "env" {
}

variable "secondary_cidr_blocks" {
  description = "A list of strings containing the CIDR notation of the entire extra subnet to be split between AZs."
  type        = list(string)
  default     = []
}

variable "name" {
  type        = string
  description = "A string to fill the standard name tag."
}

variable "public_subnet_count" {
  description = "The amount of subnets to split the cidrs in to on public subnets."
  default     = 3
}

variable "private_subnet_count" {
  description = "The amount of subnets to split the cidrs in to on private subnets."
  default     = 3
}

variable "public_newbits" {
  default = 8
}

variable "private_newbits" {
  default = 8
}


variable "public_netnum" {
  default = 0
}

variable "private_netnum" {
  default = 4
}

variable "dns_servers" {
  type    = list(string)
  default = []
}

variable "domain_name" {
  default = ""
}

variable "domain_name_servers" {
  type    = list(string)
  default = ["AmazonProvidedDNS"]
}

variable "nat_gateway_count" {
  default = 1
}

variable "creator" {
  default = "Managed by Terraform"
}