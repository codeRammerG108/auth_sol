resource "aws_api_gateway_rest_api" "composable_auth_api_gateway" {
  name = "${var.project_name}_composable_auth_api_gateway"
  count = var.create_resource ? 1 : 0
}
 
resource "aws_api_gateway_resource" "resource" {
  path_part   = "add-user"
  count = var.create_resource ? 1 : 0
  depends_on = [aws_api_gateway_rest_api.composable_auth_api_gateway]
  parent_id   = aws_api_gateway_rest_api.composable_auth_api_gateway[count.index].root_resource_id
  rest_api_id = aws_api_gateway_rest_api.composable_auth_api_gateway[count.index].id
}
 
resource "aws_api_gateway_method" "method" {
  count = var.create_resource ? 1 : 0
  depends_on = [aws_api_gateway_rest_api.composable_auth_api_gateway]
  rest_api_id   = aws_api_gateway_rest_api.composable_auth_api_gateway[count.index].id
  resource_id   = aws_api_gateway_resource.resource[count.index].id
  http_method   = "POST"
  authorization = "NONE"
}
 
resource "aws_api_gateway_integration" "integration" {
  count = var.create_resource ? 1 : 0
  depends_on = [aws_api_gateway_rest_api.composable_auth_api_gateway]
  rest_api_id             = aws_api_gateway_rest_api.composable_auth_api_gateway[count.index].id
  resource_id             = aws_api_gateway_resource.resource[count.index].id
  http_method             = aws_api_gateway_method.method[count.index].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.add_cognito_user[count.index].invoke_arn
}
 
resource "aws_api_gateway_deployment" "composable_auth_api_gateway_deployment" {
  count = var.create_resource ? 1 : 0
  depends_on  = [aws_api_gateway_rest_api.composable_auth_api_gateway]
  rest_api_id = aws_api_gateway_rest_api.composable_auth_api_gateway[count.index].id
 
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.composable_auth_api_gateway[count.index].body))
  }
 
  lifecycle {
    create_before_destroy = true
  }
}
 
resource "aws_api_gateway_stage" "example" {
  count = var.create_resource ? 1 : 0
  depends_on = [aws_api_gateway_deployment.composable_auth_api_gateway_deployment]
  deployment_id = aws_api_gateway_deployment.composable_auth_api_gateway_deployment[count.index].id
  rest_api_id   = aws_api_gateway_rest_api.composable_auth_api_gateway[count.index].id
  stage_name    = "dev"
}