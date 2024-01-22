# Composable Solution Auth
 
Composable Solution Auth is a solution for passwordless authentication.
 
## How to run this project
 
Use these commands to deploy backend.
 
```bash
npm install
npm run dist:service
cd terraform
terraform init
terraform plan
terraform apply
```


```
$ terraform plan
data.archive_file.pre_signup: Reading...
data.archive_file.define_auth_challenge: Reading...
data.archive_file.create_auth_challenge: Reading...
data.archive_file.verify_auth_challenge_response: Reading...
data.archive_file.create_auth_challenge: Read complete after 0s [id=d368e721c57f3e3aad117c91af4b2984aa69f792]
data.archive_file.pre_signup: Read complete after 1s [id=e94f26ecde235beba2e212d1739830b70edaed32]
data.archive_file.verify_auth_challenge_response: Read complete after 1s [id=e4cc228d50b10c8fd5b451c8eee4745512cf0d17]
data.archive_file.define_auth_challenge: Read complete after 1s [id=a0dacfb2d3bb3c8aec8c2f54200a6afeb89d8391]
data.aws_region.current: Reading...
data.aws_caller_identity.current: Reading...
data.aws_region.current: Read complete after 0s [id=us-west-2]
data.aws_caller_identity.current: Read complete after 0s [id=596891947105]

Terraform used the selected providers to generate the following execution plan. Resource  
actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_cognito_user_pool.composable_auth_user_pool will be created
  + resource "aws_cognito_user_pool" "composable_auth_user_pool" {
      + arn                        = (known after apply)
      + creation_date              = (known after apply)
      + custom_domain              = (known after apply)
      + deletion_protection        = "INACTIVE"
      + domain                     = (known after apply)
      + email_verification_message = (known after apply)
      + email_verification_subject = (known after apply)
      + endpoint                   = (known after apply)
      + estimated_number_of_users  = (known after apply)
      + id                         = (known after apply)
      + last_modified_date         = (known after apply)
      + mfa_configuration          = "OFF"
      + name                       = "temp_solution_project_user_pool"
      + sms_verification_message   = (known after apply)
      + tags_all                   = (known after apply)
      + username_attributes        = [
          + "email",
        ]

      + account_recovery_setting {
          + recovery_mechanism {
              + name     = "verified_email"
              + priority = 1
            }
        }

      + lambda_config {
          + create_auth_challenge          = (known after apply)
          + define_auth_challenge          = (known after apply)
          + pre_sign_up                    = (known after apply)
          + verify_auth_challenge_response = (known after apply)
        }

      + password_policy {
          + minimum_length                   = 8
          + require_lowercase                = true
          + require_numbers                  = true
          + require_symbols                  = true
          + require_uppercase                = true
          + temporary_password_validity_days = 7
        }

      + schema {
          + attribute_data_type = "String"
          + mutable             = true
          + name                = "email"
          + required            = true
        }
    }

  # aws_cognito_user_pool_client.composable_auth_user_pool_client will be created
  + resource "aws_cognito_user_pool_client" "composable_auth_user_pool_client" {
      + access_token_validity                         = 5
      + allowed_oauth_flows                           = (known after apply)
      + allowed_oauth_flows_user_pool_client          = (known after apply)
      + allowed_oauth_scopes                          = (known after apply)
      + auth_session_validity                         = (known after apply)
      + callback_urls                                 = (known after apply)
      + client_secret                                 = (sensitive value)
      + default_redirect_uri                          = (known after apply)
      + enable_propagate_additional_user_context_data = (known after apply)
      + enable_token_revocation                       = (known after apply)
      + explicit_auth_flows                           = [
          + "ALLOW_ADMIN_USER_PASSWORD_AUTH",
          + "ALLOW_CUSTOM_AUTH",
          + "ALLOW_REFRESH_TOKEN_AUTH",
          + "ALLOW_USER_PASSWORD_AUTH",
          + "ALLOW_USER_SRP_AUTH",
        ]
      + id                                            = (known after apply)
      + id_token_validity                             = 5
      + logout_urls                                   = (known after apply)
      + name                                          = "ui-end-client"
      + prevent_user_existence_errors                 = (known after apply)
      + read_attributes                               = (known after apply)
      + refresh_token_validity                        = 60
      + supported_identity_providers                  = (known after apply)
      + user_pool_id                                  = (known after apply)
      + write_attributes                              = (known after apply)

      + token_validity_units {
          + access_token  = "minutes"
          + id_token      = "minutes"
          + refresh_token = "minutes"
        }
    }

  # aws_dynamodb_table.dynamodb_table will be created
  + resource "aws_dynamodb_table" "dynamodb_table" {
      + arn              = (known after apply)
      + billing_mode     = "PAY_PER_REQUEST"
      + hash_key         = "userNameHash"
      + id               = (known after apply)
      + name             = "temp_solution_project_SecretsTablePasswordless"
      + read_capacity    = (known after apply)
      + stream_arn       = (known after apply)
      + stream_label     = (known after apply)
      + stream_view_type = (known after apply)
      + tags_all         = (known after apply)
      + write_capacity   = (known after apply)

      + attribute {
          + name = "userNameHash"
          + type = "B"
        }

      + ttl {
          + attribute_name = "exp"
          + enabled        = true
        }
    }

  # aws_iam_policy.policy_create_auth_challenge will be created
  + resource "aws_iam_policy" "policy_create_auth_challenge" {
      + arn         = (known after apply)
      + description = "AWS IAM Policy for managing AWS Lambda role"
      + id          = (known after apply)
      + name        = "temp_solution_project_aws_policy_create_auth_challenge"
      + name_prefix = (known after apply)
      + path        = "/"
      + policy      = (known after apply)
      + policy_id   = (known after apply)
      + tags_all    = (known after apply)
    }

  # aws_iam_policy.policy_define_auth_challenge will be created
  + resource "aws_iam_policy" "policy_define_auth_challenge" {
      + arn         = (known after apply)
      + description = "AWS IAM Policy for managing AWS Lambda role"
      + id          = (known after apply)
      + name        = "temp_solution_project_aws_policy_define_auth_challenges"
      + name_prefix = (known after apply)
      + path        = "/"
      + policy      = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = [
                          + "logs:CreateLogGroup",
                          + "logs:CreateLogStream",
                          + "logs:PutLogEvents",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + policy_id   = (known after apply)
      + tags_all    = (known after apply)
    }

  # aws_iam_policy.policy_presignup will be created
  + resource "aws_iam_policy" "policy_presignup" {
      + arn         = (known after apply)
      + description = "AWS IAM Policy for managing aws lambda role"
      + id          = (known after apply)
      + name        = "temp_solution_project_aws_policy_presignup"
      + name_prefix = (known after apply)
      + path        = "/"
      + policy      = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = [
                          + "logs:CreateLogGroup",
                          + "logs:CreateLogStream",
                          + "logs:PutLogEvents",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + policy_id   = (known after apply)
      + tags_all    = (known after apply)
    }

  # aws_iam_policy.policy_verify_auth_challenege will be created
  + resource "aws_iam_policy" "policy_verify_auth_challenege" {
      + arn         = (known after apply)
      + description = "AWS IAM Policy for managing AWS Lambda role"
      + id          = (known after apply)
      + name        = "temp_solution_project_aws_policy_verify_auth_challenge"
      + name_prefix = (known after apply)
      + path        = "/"
      + policy      = (known after apply)
      + policy_id   = (known after apply)
      + tags_all    = (known after apply)
    }

  # aws_iam_role.role_create_auth_challenge will be created
  + resource "aws_iam_role" "role_create_auth_challenge" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "lambda.amazonaws.com"
                        }
                      + Sid       = ""
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "temp_solution_project_create_auth_challenges"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = (known after apply)
      + unique_id             = (known after apply)
    }

  # aws_iam_role.role_define_auth_challenge will be created
  + resource "aws_iam_role" "role_define_auth_challenge" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "lambda.amazonaws.com"
                        }
                      + Sid       = ""
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "temp_solution_project_define_auth_challenge"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = (known after apply)
      + unique_id             = (known after apply)
    }

  # aws_iam_role.role_presignup will be created
  + resource "aws_iam_role" "role_presignup" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "lambda.amazonaws.com"
                        }
                      + Sid       = ""
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "temp_solution_project_PreSignup"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = (known after apply)
      + unique_id             = (known after apply)
    }

  # aws_iam_role.role_verify_auth_challenge will be created
  + resource "aws_iam_role" "role_verify_auth_challenge" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "lambda.amazonaws.com"
                        }
                      + Sid       = ""
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "temp_solution_project_verify_auth_challenge"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = (known after apply)
      + unique_id             = (known after apply)
    }

  # aws_iam_role_policy_attachment.policy_attachment_create_auth_challenge will be created
  + resource "aws_iam_role_policy_attachment" "policy_attachment_create_auth_challenge" { 
      + id         = (known after apply)
      + policy_arn = (known after apply)
      + role       = "temp_solution_project_create_auth_challenges"
    }

  # aws_iam_role_policy_attachment.policy_attachment_define_auth_challenge will be created
  + resource "aws_iam_role_policy_attachment" "policy_attachment_define_auth_challenge" { 
      + id         = (known after apply)
      + policy_arn = (known after apply)
      + role       = "temp_solution_project_define_auth_challenge"
    }

  # aws_iam_role_policy_attachment.policy_attachment_presignup will be created
  + resource "aws_iam_role_policy_attachment" "policy_attachment_presignup" {
      + id         = (known after apply)
      + policy_arn = (known after apply)
      + role       = "temp_solution_project_PreSignup"
    }

  # aws_iam_role_policy_attachment.policy_attachment_verify_auth_challenge will be created
  + resource "aws_iam_role_policy_attachment" "policy_attachment_verify_auth_challenge" { 
      + id         = (known after apply)
      + policy_arn = (known after apply)
      + role       = "temp_solution_project_verify_auth_challenge"
    }

  # aws_kms_alias.composable_solution_auth_kms_alias will be created
  + resource "aws_kms_alias" "composable_solution_auth_kms_alias" {
      + arn            = (known after apply)
      + id             = (known after apply)
      + name           = "alias/temp_solution_project_kms_alias"
      + name_prefix    = (known after apply)
      + target_key_arn = (known after apply)
      + target_key_id  = (known after apply)
    }

  # aws_kms_key.composable_authentication_solution_kms will be created
  + resource "aws_kms_key" "composable_authentication_solution_kms" {
      + arn                                = (known after apply)
      + bypass_policy_lockout_safety_check = false
      + customer_master_key_spec           = "RSA_2048"
      + description                        = "temp_solution_project_KMS_stack"
      + enable_key_rotation                = false
      + id                                 = (known after apply)
      + is_enabled                         = true
      + key_id                             = (known after apply)
      + key_usage                          = "SIGN_VERIFY"
      + multi_region                       = (known after apply)
      + policy                             = (known after apply)
      + tags_all                           = (known after apply)
    }

  # aws_lambda_function.create_auth_challenge will be created
  + resource "aws_lambda_function" "create_auth_challenge" {
      + architectures                  = [
          + "arm64",
        ]
      + arn                            = (known after apply)
      + filename                       = "./../dist/lambda/create_auth_challenge.zip"     
      + function_name                  = "temp_solution_project_create_auth_challenge"    
      + handler                        = "index.handler"
      + id                             = (known after apply)
      + invoke_arn                     = (known after apply)
      + last_modified                  = (known after apply)
      + memory_size                    = 128
      + package_type                   = "Zip"
      + publish                        = false
      + qualified_arn                  = (known after apply)
      + qualified_invoke_arn           = (known after apply)
      + reserved_concurrent_executions = -1
      + role                           = (known after apply)
      + runtime                        = "nodejs18.x"
      + signing_job_arn                = (known after apply)
      + signing_profile_version_arn    = (known after apply)
      + skip_destroy                   = false
      + source_code_hash               = "8Ma3CuHD82OObsy6MZWqOBRXrynnfl0Id/tQMVEbDmA="   
      + source_code_size               = (known after apply)
      + tags_all                       = (known after apply)
      + timeout                        = 5
      + version                        = (known after apply)

      + environment {
          + variables = {
              + "ALLOWED_ORIGINS"        = "http://localhost:5173"
              + "DYNAMODB_SECRETS_TABLE" = "temp_solution_project_SecretsTablePasswordless"
              + "KMS_KEY_ID"             = "alias/temp_solution_project_kms_alias"        
              + "MAGIC_LINK_ENABLED"     = "TRUE"
              + "MIN_SECONDS_BETWEEN"    = "60"
              + "SALT"                   = "ABHI24"
              + "SECONDS_UNTIL_EXPIRY"   = "900"
              + "SES_FROM_ADDRESS"       = "Abhishek.Sandliya@triconinfotech.com"
              + "SES_REGION"             = "us-west-2"
            }
        }
    }

  # aws_lambda_function.define_auth_challenge will be created
  + resource "aws_lambda_function" "define_auth_challenge" {
      + architectures                  = [
          + "arm64",
        ]
      + arn                            = (known after apply)
      + filename                       = "./../dist/lambda/define_auth_challenge.zip"     
      + function_name                  = "temp_solution_project_define_auth_challenge"    
      + handler                        = "index.handler"
      + id                             = (known after apply)
      + invoke_arn                     = (known after apply)
      + last_modified                  = (known after apply)
      + memory_size                    = 128
      + package_type                   = "Zip"
      + publish                        = false
      + qualified_arn                  = (known after apply)
      + qualified_invoke_arn           = (known after apply)
      + reserved_concurrent_executions = -1
      + role                           = (known after apply)
      + runtime                        = "nodejs18.x"
      + signing_job_arn                = (known after apply)
      + signing_profile_version_arn    = (known after apply)
      + skip_destroy                   = false
      + source_code_hash               = "v3JeD1mFGHl2qQa+Z+Mbl6p2O0KhYQy5timI6VlVlyE="   
      + source_code_size               = (known after apply)
      + tags_all                       = (known after apply)
      + timeout                        = 5
      + version                        = (known after apply)

      + environment {
          + variables = {
              + "LOG_LEVEL" = "DEBUG"
            }
        }
    }

  # aws_lambda_function.pre_signup will be created
  + resource "aws_lambda_function" "pre_signup" {
      + architectures                  = [
          + "arm64",
        ]
      + arn                            = (known after apply)
      + filename                       = "./../dist/lambda/pre_signup.zip"
      + function_name                  = "temp_solution_project_pre_signup"
      + handler                        = "index.handler"
      + id                             = (known after apply)
      + invoke_arn                     = (known after apply)
      + last_modified                  = (known after apply)
      + memory_size                    = 128
      + package_type                   = "Zip"
      + publish                        = false
      + qualified_arn                  = (known after apply)
      + qualified_invoke_arn           = (known after apply)
      + reserved_concurrent_executions = -1
      + role                           = (known after apply)
      + runtime                        = "nodejs18.x"
      + signing_job_arn                = (known after apply)
      + signing_profile_version_arn    = (known after apply)
      + skip_destroy                   = false
      + source_code_hash               = "IOi9vSUkq6v9po3175bDtmWVaUaBRpJG/k1rbvJpkxc="   
      + source_code_size               = (known after apply)
      + tags_all                       = (known after apply)
      + timeout                        = 5
      + version                        = (known after apply)

      + environment {
          + variables = {
              + "LOG_LEVEL" = "DEBUG"
            }
        }
    }

  # aws_lambda_function.verify_auth_challenge_response will be created
  + resource "aws_lambda_function" "verify_auth_challenge_response" {
      + architectures                  = (known after apply)
      + arn                            = (known after apply)
      + filename                       = "./../dist/lambda/verify_auth_challenge_response.zip"
      + function_name                  = "temp_solution_project_verify_auth_challenge_response"
      + handler                        = "index.handler"
      + id                             = (known after apply)
      + invoke_arn                     = (known after apply)
      + last_modified                  = (known after apply)
      + memory_size                    = 128
      + package_type                   = "Zip"
      + publish                        = false
      + qualified_arn                  = (known after apply)
      + qualified_invoke_arn           = (known after apply)
      + reserved_concurrent_executions = -1
      + role                           = (known after apply)
      + runtime                        = "nodejs18.x"
      + signing_job_arn                = (known after apply)
      + signing_profile_version_arn    = (known after apply)
      + skip_destroy                   = false
      + source_code_hash               = "fpARyQmcrik6Nu0OYnnNeyXlx7uGxbW0qSPlqa4w0Lg="   
      + source_code_size               = (known after apply)
      + tags_all                       = (known after apply)
      + timeout                        = 3
      + version                        = (known after apply)

      + environment {
          + variables = {
              + "ALLOWED_ORIGINS"        = "http://localhost:5173"
              + "DYNAMODB_SECRETS_TABLE" = "temp_solution_project_SecretsTablePasswordless"
              + "LOG_LEVEL"              = "DEBUG"
              + "MAGIC_LINK_ENABLED"     = "TRUE"
              + "SALT"                   = "ABHI24"
            }
        }
    }

  # aws_lambda_permission.resource_policy_create_auth will be created
  + resource "aws_lambda_permission" "resource_policy_create_auth" {
      + action              = "lambda:InvokeFunction"
      + function_name       = "temp_solution_project_create_auth_challenge"
      + id                  = (known after apply)
      + principal           = "cognito-idp.amazonaws.com"
      + source_arn          = (known after apply)
      + statement_id        = (known after apply)
      + statement_id_prefix = (known after apply)
    }

  # aws_lambda_permission.resource_policy_define_auth will be created
  + resource "aws_lambda_permission" "resource_policy_define_auth" {
      + action              = "lambda:InvokeFunction"
      + function_name       = "temp_solution_project_define_auth_challenge"
      + id                  = (known after apply)
      + principal           = "cognito-idp.amazonaws.com"
      + source_arn          = (known after apply)
      + statement_id        = (known after apply)
      + statement_id_prefix = (known after apply)
    }

  # aws_lambda_permission.resource_policy_pre_signup will be created
  + resource "aws_lambda_permission" "resource_policy_pre_signup" {
      + action              = "lambda:InvokeFunction"
      + function_name       = "temp_solution_project_pre_signup"
      + id                  = (known after apply)
      + principal           = "cognito-idp.amazonaws.com"
      + source_arn          = (known after apply)
      + statement_id        = (known after apply)
      + statement_id_prefix = (known after apply)
    }

  # aws_lambda_permission.resource_policy_verify_auth will be created
  + resource "aws_lambda_permission" "resource_policy_verify_auth" {
      + action              = "lambda:InvokeFunction"
      + function_name       = "temp_solution_project_verify_auth_challenge_response"      
      + id                  = (known after apply)
      + principal           = "cognito-idp.amazonaws.com"
      + source_arn          = (known after apply)
      + statement_id        = (known after apply)
      + statement_id_prefix = (known after apply)
    }

Plan: 25 to add, 0 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────── 

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to   
take exactly these actions if you run "terraform apply" now.
```