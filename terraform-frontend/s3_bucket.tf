resource "aws_s3_bucket" "composable_auth_frontend_bucket" {
  bucket = "composable-auth-frontend-bucket-1"
}
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.composable_auth_frontend_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
# resource "aws_s3_object" "example" {
#   key                    = "frontend"
#   bucket                 = aws_s3_bucket.composable_auth_frontend_bucket.id
#   source                 = "index.html"
#   server_side_encryption = "aws:kms"
# }
resource "aws_s3_bucket_policy" "allow_access" {
  bucket = aws_s3_bucket.composable_auth_frontend_bucket.id
  policy = data.aws_iam_policy_document.allow_access.json
}

data "aws_iam_policy_document" "allow_access" {
  statement {
    sid =  "EnforceTLS"
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
       "s3:*"
            ]

    resources = [
           "${aws_s3_bucket.composable_auth_frontend_bucket.arn}/*"
    ]
    condition {
      test     = "Bool"
    
      variable = "aws:SecureTransport"
      values   = [false]
      
    }
    
  }
  
 

  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.example.id}"]
    }

    actions = [
    "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.composable_auth_frontend_bucket.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_acl" "b_acl" {
  bucket = aws_s3_bucket.composable_auth_frontend_bucket.id
  acl    = "private"
}

