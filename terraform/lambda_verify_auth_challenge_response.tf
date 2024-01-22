# IAM Role for Lambda
resource "aws_iam_role" "role_verify_auth_challenge" {
  name = "${var.project_name}_verify_auth_challenge"

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
  resource "aws_iam_policy" "policy_verify_auth_challenege" {
    name        = "${var.project_name}_aws_policy_verify_auth_challenge"
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
      "Action": "kms:GetPublicKey",
      "Resource": [
        "${aws_kms_key.composable_authentication_solution_kms.arn}"
      ],
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
resource "aws_iam_role_policy_attachment" "policy_attachment_verify_auth_challenge" {
  role       = aws_iam_role.role_verify_auth_challenge.name
  policy_arn = aws_iam_policy.policy_verify_auth_challenege.arn
  depends_on = [ aws_kms_key.composable_authentication_solution_kms ]

}


data "archive_file" "verify_auth_challenge_response" {
 type        = "zip"
 source_file  = "${path.module}/../dist/service/custom-auth/verify-auth-challenge-response/index.mjs"
 output_path = "${path.module}/../dist/lambda/verify_auth_challenge_response.zip"
}
 
# Create a lambda function
# In terraform ${path.module} is the current directory.
resource "aws_lambda_function" "verify_auth_challenge_response" {
 filename                       = "${path.module}/../dist/lambda/verify_auth_challenge_response.zip"
 function_name                  = "${var.project_name}_verify_auth_challenge_response"
 role                           =  aws_iam_role.role_verify_auth_challenge.arn
 handler                        = "index.handler"
 source_code_hash = data.archive_file.verify_auth_challenge_response.output_base64sha256
 runtime                        = "nodejs18.x"
 depends_on                     = [aws_iam_role_policy_attachment.policy_attachment_verify_auth_challenge]
 environment  {
    variables = {

      ALLOWED_ORIGINS = join(",", var.allowed_origins)

      DYNAMODB_SECRETS_TABLE = aws_dynamodb_table.dynamodb_table.name

      MAGIC_LINK_ENABLED = "TRUE"

      LOG_LEVEL = var.log_level

      SALT = var.SALT
    }
  }
}
 
# Lambda Resource Policy
resource "aws_lambda_permission" "resource_policy_verify_auth" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.verify_auth_challenge_response.function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.composable_auth_user_pool.arn
}