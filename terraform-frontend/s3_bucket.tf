resource "aws_s3_bucket" "magic-link-auth-frontend-bucket" {
  bucket = "magic-link-auth-frontend-bucket"
  acl="private"
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.magic-link-auth-frontend-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "allow_access" {
  bucket = aws_s3_bucket.magic-link-auth-frontend-bucket.id
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
           "${aws_s3_bucket.magic-link-auth-frontend-bucket.arn}/*"
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
      "${aws_s3_bucket.magic-link-auth-frontend-bucket.arn}/*"
    ]
  }
}

