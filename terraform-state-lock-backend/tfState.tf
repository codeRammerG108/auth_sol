resource "aws_s3_bucket" "backendS3" {
  bucket = "tfstate-magiclink-solution-auth"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.backendS3.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.backendS3.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
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