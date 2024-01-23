provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket         = "tfstate-magiclink-auth"
    dynamodb_table = "tfstate-magiclink"
    key            = "states"
    region         = "us-west-2"
    encrypt        = true
  }
}

