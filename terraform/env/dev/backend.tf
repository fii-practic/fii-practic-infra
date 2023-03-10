terraform {
  backend "s3" {
    bucket  = "fii-practic-terraform-state"
    key     = "terraform.tfstate"
    region  = "eu-west-1"
    acl     = "bucket-owner-full-control"
    encrypt = "true"
    profile = "fii-practic"
  }
}

