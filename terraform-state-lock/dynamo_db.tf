provider "aws" {
  region = "us-west-2"
}
resource "aws_dynamodb_table" "dynamodb_table" {
  name         = "tfstates-composable-solution-auth-lock-frontend"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}