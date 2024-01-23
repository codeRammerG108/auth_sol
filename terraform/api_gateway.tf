# Variables
variable "myregion" {}

variable "accountId" {}

# API Gateway
resource "aws_api_gateway_rest_api" "composable_auth_api_gateway" {
  name = "${var.project_name}_composable_auth_api_gateway"
}

resource "aws_api_gateway_resource" "resource" {
  path_part   = "add-user"
  parent_id   = aws_api_gateway_rest_api.composable_auth_api_gateway.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.composable_auth_api_gateway.id
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.composable_auth_api_gateway.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.composable_auth_api_gateway.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.add_cognito_user.invoke_arn
}

resource "aws_api_gateway_deployment" "composable_auth_api_gateway_deployment" {
  depends_on = [aws_api_gateway_rest_api.composable_auth_api_gateway,aws_api_gateway_method.method,aws_api_gateway_integration.integration]
  rest_api_id = aws_api_gateway_rest_api.composable_auth_api_gateway.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.composable_auth_api_gateway.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.composable_auth_api_gateway_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.composable_auth_api_gateway.id
  stage_name    = "dev"
}