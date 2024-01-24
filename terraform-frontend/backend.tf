provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket         = "tfstates-composable-solution-auth-frontend"
    dynamodb_table = "tfstates-composable-solution-auth-lock-frontend"
    key            = "states"
    region         = "us-west-2"
    encrypt        = true
  }
}

