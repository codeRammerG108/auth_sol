# IAM Role for Lambda
resource "aws_iam_role" "role_define_auth_challenge" {
  name = "${var.project_name}_define_auth_challenge"

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
  resource "aws_iam_policy" "policy_define_auth_challenge" {
    name        = "${var.project_name}_aws_policy_define_auth_challenges"
    description = "AWS IAM Policy for managing AWS Lambda role"
    policy=<<EOF
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

# Attach IAM Policy to IAM Role
resource "aws_iam_role_policy_attachment" "policy_attachment_define_auth_challenge" {
  role       = aws_iam_role.role_define_auth_challenge.name
  policy_arn = aws_iam_policy.policy_define_auth_challenge.arn
}

# Lambda Deployment Package
data "archive_file" "define_auth_challenge" {
  type        = "zip"
  source_file = "${path.module}/../dist/service/custom-auth/define-auth-challenge/index.mjs"
  output_path = "${path.module}/../dist/lambda/define_auth_challenge.zip"
}

# Create a lambda function
# In terraform ${path.module} is the current directory.
resource "aws_lambda_function" "define_auth_challenge" {
 filename                       = "${path.module}/../dist/lambda/define_auth_challenge.zip"
 function_name                  = "${var.project_name}_define_auth_challenge"
 role                           =  aws_iam_role.role_define_auth_challenge.arn
 handler                        = "index.handler"
 runtime                        = "nodejs18.x"
 timeout                        = 5
 source_code_hash = data.archive_file.define_auth_challenge.output_base64sha256
 architectures                  = ["arm64"]
 depends_on                     = [aws_iam_role_policy_attachment.policy_attachment_define_auth_challenge]
 environment {
   variables = {
     LOG_LEVEL = var.log_level
   }
 }
}

    
# Lambda Resource Policy
resource "aws_lambda_permission" "resource_policy_define_auth" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.define_auth_challenge.function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.composable_auth_user_pool.arn
}

 