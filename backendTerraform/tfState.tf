resource "aws_s3_bucket" "backendS3" {
  bucket = "tfstate-magiclink-solution-auth"
}

resource "aws_dynamodb_table" "backendDynamoDB" {
  name = "tfstate-magiclink-solution-auth-lock"
  hash_key = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
}