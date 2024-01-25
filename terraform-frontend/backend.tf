provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket         = "tfstate-magiclink-solution-auth-frontend"
    dynamodb_table = "tfstate-magiclink-solution-auth-lock-frontend"
    key            = "states"
    region         = "us-west-2"
    encrypt        = true
  }
}

