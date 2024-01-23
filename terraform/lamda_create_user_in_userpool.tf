# IAM Role for Lambda
resource "aws_iam_role" "role_add_cognito_user" {
  name = "${var.project_name}_add_cognito_user"

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
resource "aws_iam_policy" "policy_add_cognito_user" {
  name        = "${var.project_name}_aws_policy_add_cognito_user"
  description = "AWS IAM Policy for managing AWS Lambda role"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "Statement1",
        "Effect" : "Allow",
        "Action" : [
          "cognito-idp:AdminCreateUser"
        ],
        "Resource" : [
          "${aws_cognito_user_pool.composable_auth_user_pool.arn}"
        ]
      }
    ]
  })
}

# Attach IAM Policy to IAM Role
resource "aws_iam_role_policy_attachment" "policy_attachment_add_cognito_user" {
  role       = aws_iam_role.role_add_cognito_user.name
  policy_arn = aws_iam_policy.policy_add_cognito_user.arn
}

# Lambda Deployment Package
data "archive_file" "add_cognito_user" {
  type        = "zip"
  source_file = "${path.module}/../dist/service/custom-auth/create-user/index.mjs"
  output_path = "${path.module}/../dist/lambda/create_user.zip"
}

# Lambda Function
resource "aws_lambda_function" "add_cognito_user" {
  function_name    = "${var.project_name}_add_cognito_user"
  role             = aws_iam_role.role_add_cognito_user.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  architectures    = ["arm64"]
  timeout          = 5
  filename         = data.archive_file.add_cognito_user.output_path
  source_code_hash = data.archive_file.add_cognito_user.output_base64sha256
  depends_on       = [aws_iam_role_policy_attachment.policy_attachment_add_cognito_user, aws_cognito_user_pool.composable_auth_user_pool]
  environment {
    variables = {
      USER_POOL_ID = aws_cognito_user_pool.composable_auth_user_pool.id
    }
  }

}

#Lambda Resource Policy
resource "aws_lambda_permission" "resource_policy_create_users" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.add_cognito_user.function_name
  principal     = "apigateway.amazonaws.com"
 # source_arn    = "${aws_api_gateway_rest_api.composable_auth_api_gateway.arn}"
   source_arn = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.composable_auth_api_gateway.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}
