provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  region  = "eu-west-1"
  profile = default
  alias   = "dev"
}

provider "aws" {
  region  = "eu-west-1"
  profile = default
  alias   = "prod"
}
