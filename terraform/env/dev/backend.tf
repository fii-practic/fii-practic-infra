terraform {
  backend "s3" {
    bucket  = "fii-practic-terraform-state"
    key     = "dev/terraform.tfstate"
    region  = "eu-west-1"
    profile = "default"
  }
}

