variable "cluster_id" {
  default = ""
}

variable "node_type" {
  default = "cache.t3.micro"
}

variable "num_cache_nodes" {
  default = "1"
}

variable "name" {
  default = ""
}

variable "replication_group_id" {
  default = ""
}

variable "engine_version" {
  default = "6.x"
}

variable "maintenance_window" {
  default = "sun:05:00-sun:06:00"
}

variable "automatic_failover_enabled" {
  default = false
}

variable "auto_minor_version_upgrade" {
  default = true
}

variable "parameter_group_name" {
  default = "default.redis6.x"
}

variable "port" {
  default = "6379"
}

variable "subnet_ids" {
  type        = list(any)
  description = "List of subnets ids where the redis instance can live, eg. [subnet-6412a148,subnet-e18b0185]"
}

variable "vpc_id" {
}

variable "trusted_cidrs" {
  type = list(any)
}

variable "trusted_security_groups" {
  type    = list(string)
  default = []
}

variable "route53_zone_id" {
  default = ""
}

