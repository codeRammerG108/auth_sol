resource "aws_cognito_user_pool" "composable_auth_user_pool" {
  name = "${var.project_name}_user_pool"

  mfa_configuration = "OFF"

  password_policy {
    minimum_length    = 8
    require_numbers   = true
    require_uppercase = true
    require_lowercase = true
    require_symbols   = true
    temporary_password_validity_days = 7
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  username_attributes = ["email"]


  schema {
    attribute_data_type = "String"
    name                = "email"
    required            = true
    mutable             = true
  }

  lambda_config {
    define_auth_challenge          = aws_lambda_function.define_auth_challenge.arn
    create_auth_challenge          = aws_lambda_function.create_auth_challenge.arn
    verify_auth_challenge_response = aws_lambda_function.verify_auth_challenge_response.arn
    pre_sign_up                    = aws_lambda_function.pre_signup.arn
  }
}



resource "aws_cognito_user_pool_client" "composable_auth_user_pool_client" {
  name = "ui-end-client"

  user_pool_id = aws_cognito_user_pool.composable_auth_user_pool.id

  access_token_validity = 5

  id_token_validity = 5

  refresh_token_validity = 60

  explicit_auth_flows = ["ALLOW_ADMIN_USER_PASSWORD_AUTH", "ALLOW_CUSTOM_AUTH", "ALLOW_USER_PASSWORD_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]

  token_validity_units {     
    id_token     = "minutes"     
    access_token = "minutes"     
    refresh_token = "minutes"   
  }

}



