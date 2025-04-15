terraform {
  backend "s3" {
    bucket       = "fii-practic-954976320138-terraform-state"
    key          = "dev/terraform.tfstate"
    region       = "eu-west-1"
    profile      = "default"
    use_lockfile = true
  }
}

