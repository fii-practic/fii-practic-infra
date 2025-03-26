variable "bucket" {
  description = "The name of the bucket."
  default     = ""
}

variable "acl" {
  description = "The canned ACL to apply"
  default     = "private"
}


variable "tags" {
  type        = map(any)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error."
  default     = false
}

variable "website" {
  description = "A website object."
  default     = {}
  type        = map(any)
}

variable "cors_rule" {
  description = "A rule of Cross-Origin Resource Sharing."
  default     = {}
  type        = map(any)
}

variable "versioning" {
  description = "A state of versioning."
  default     = false
}

variable "logging" {
  description = "A settings of bucket logging."
  default     = {}
  type        = map(any)
}

variable "lifecycle_rule" {
  description = "A configuration of object lifecycle management."
  default     = []
  type        = list(any)
}

variable "region" {
  description = "the AWS region this bucket should reside in."
  default     = "eu-west-1"
}

variable "request_payer" {
  description = "Specifies who should bear the cost of Amazon S3 data transfer."
  default     = "BucketOwner"
}

variable "replication_configuration" {
  description = "A configuration of replication configuration."
  default     = {}
  type        = map(any)
}

variable "server_side_encryption_configuration" {
  description = "A configuration of server-side encryption configuration."
  default     = {}
  type        = map(any)
}

variable "principal" {
  description = "principal"
  default     = "*"
}

variable "allow_public" {
  description = "Allow public read access to bucket"
  default     = false
}

variable "create_bucket" {
  description = "Conditionally create S3 bucket"
  default     = true
}
variable "policy" {
  description = "Policy file path"
  default     = ""
}
