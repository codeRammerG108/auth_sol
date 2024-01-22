# IAM Role for Lambda
resource "aws_iam_role" "role_create_auth_challenge" {
  name = "${var.project_name}_create_auth_challenges"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax. 
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

# IAM Policy for Lambda
  resource "aws_iam_policy" "policy_create_auth_challenge" {
    name        = "${var.project_name}_aws_policy_create_auth_challenge"
    description = "AWS IAM Policy for managing AWS Lambda role"
    policy=<<EOF
{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
          ],
        "Resource": "*"
        },
        {
          "Effect": "Allow",
          "Action": [
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:ConditionCheckItem",
          "dynamodb:DeleteItem",
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:GetRecords",
          "dynamodb:GetShardIterator",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:UpdateItem"
          ],
        "Resource": [
            "${aws_dynamodb_table.dynamodb_table.arn}"
        ]
      },
    {
      "Effect": "Allow",
      "Action": "ses:SendEmail",
      "Resource": "arn:aws:ses:us-west-2:${data.aws_caller_identity.current.account_id}:identity/*"
    },
    {
      "Effect": "Allow",
      "Action": "kms:Sign",
      "Resource": "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:key/*",
      "Condition": {
        "StringLike": {
          "kms:RequestAlias": "${aws_kms_alias.composable_solution_auth_kms_alias.name}"
        }
      }
    }
  ]
}
EOF
}

# Attach IAM Policy to IAM Role
resource "aws_iam_role_policy_attachment" "policy_attachment_create_auth_challenge" {
  role       = aws_iam_role.role_create_auth_challenge.name
  policy_arn = aws_iam_policy.policy_create_auth_challenge.arn
  depends_on = [ aws_kms_key.composable_authentication_solution_kms ]
}

# Lambda Deployment Package
data "archive_file" "create_auth_challenge" {
  type        = "zip"
  source_file = "${path.module}/../dist/service/custom-auth/create-auth-challenge/index.mjs"
  output_path = "${path.module}/../dist/lambda/create_auth_challenge.zip"
}

# Lambda Function
resource "aws_lambda_function" "create_auth_challenge" {
  function_name    = "${var.project_name}_create_auth_challenge"
  role             = aws_iam_role.role_create_auth_challenge.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  architectures     = [ "arm64" ]
  timeout = 5
  filename         = data.archive_file.create_auth_challenge.output_path
  source_code_hash = data.archive_file.create_auth_challenge.output_base64sha256
  depends_on       = [aws_iam_role_policy_attachment.policy_attachment_create_auth_challenge]
  environment  {
    variables = {

      ALLOWED_ORIGINS = join(",", var.allowed_origins)

      DYNAMODB_SECRETS_TABLE = aws_dynamodb_table.dynamodb_table.name

      KMS_KEY_ID = aws_kms_alias.composable_solution_auth_kms_alias.name

      MAGIC_LINK_ENABLED = "TRUE"

      MIN_SECONDS_BETWEEN = 60

      SECONDS_UNTIL_EXPIRY = 900

      SES_FROM_ADDRESS = var.ses_email

      SES_REGION = var.aws_region
      
      SALT = var.SALT
    }
  }
}

# Lambda Resource Policy
resource "aws_lambda_permission" "resource_policy_create_auth" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_auth_challenge.function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.composable_auth_user_pool.arn
}
