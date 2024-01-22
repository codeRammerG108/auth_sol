resource "aws_iam_role" "role_presignup" {
  name = "${var.project_name}_PreSignup"
 
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
 
# IAM policy for logging from a lambda
resource "aws_iam_policy" "policy_presignup" {
 
  name        = "${var.project_name}_aws_policy_presignup"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement":
    [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
 
 
 
 
 
# Policy Attachment on the role.
 
resource "aws_iam_role_policy_attachment" "policy_attachment_presignup" {
  role       = aws_iam_role.role_presignup.name
 
  policy_arn = aws_iam_policy.policy_presignup.arn
 
}
 
# Generates an archive from content, a file, or a directory of files.
 
data "archive_file" "pre_signup" {
  type        = "zip"
  source_file = "${path.module}/../dist/service/custom-auth/pre-signup/index.mjs"
  output_path = "${path.module}/../dist/lambda/pre_signup.zip"
}
 
# Create a lambda function
# In terraform ${path.module} is the current directory.
resource "aws_lambda_function" "pre_signup" {
  filename      = "${path.module}/../dist/lambda/pre_signup.zip"
  function_name = "${var.project_name}_pre_signup"
  role          = aws_iam_role.role_presignup.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  architectures = ["arm64"]
  timeout = 5
  source_code_hash = data.archive_file.pre_signup.output_base64sha256
  depends_on    = [aws_iam_role_policy_attachment.policy_attachment_presignup]
  environment {
    variables = {
      LOG_LEVEL= var.log_level
    }
  }
  
}

# Resource Policy
resource "aws_lambda_permission" "resource_policy_pre_signup" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.pre_signup.function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.composable_auth_user_pool.arn
}