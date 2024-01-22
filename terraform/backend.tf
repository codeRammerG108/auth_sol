provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "tfstates-composable-solution-auth"
    dynamodb_table = "tfstates-composable-solution-auth-lock"
    key = "states"
    region = "us-west-2"
    encrypt = true 
  }
}

