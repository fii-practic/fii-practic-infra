terraform {
  required_version = "~> 1.11"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.92.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}
