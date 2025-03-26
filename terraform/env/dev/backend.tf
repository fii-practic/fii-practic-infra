terraform {
  backend "s3" {
    #bucket  = "fii-practic-ACCOUNT-ID-terraform-state"
    bucket       = "fii-practic-terraform-state-009"
    key          = "dev/terraform.tfstate"
    region       = "eu-west-1"
    profile      = "default"
    use_lockfile = true
  }
}

