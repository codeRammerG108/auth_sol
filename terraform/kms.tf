resource "aws_kms_key" "composable_authentication_solution_kms" {
  description             = "${var.project_name}_KMS_stack"
  customer_master_key_spec = "RSA_2048"
  key_usage = "SIGN_VERIFY"
  
}

# resource "aws_kms_key_policy" "policy_kms" {
#   key_id = aws_kms_key.composable_authentication_solution_kms.id
#   policy = jsonencode({
#     Statement = [
#       {
#             "Effect": "Allow",
#             "Principal": {
#                 "AWS": "arn:aws:iam::${data.aws_caller_identity.current.id}:root"
#             },
#             "NotAction": "kms:Sign",
#             "Resource": "*"
#         },
#         {
#             "Effect": "Allow",
#             "Principal": {
#                 "AWS": aws_iam_role.role_create_auth_challenge.arn
#             },
#             "Action": "kms:Sign",
#             "Resource": "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:key/*",
#             "Condition": {
#                 "StringLike": {
#                     "kms:RequestAlias": "aws_kms_alias.composable_solution_auth_kms_alias.name"
#                 }
#             }
#         }
#     ]
#   })
#   # depends_on = [ aws_lambda_function.create_auth_challenge ]
# }



resource "aws_kms_alias" "composable_solution_auth_kms_alias" {
  name          = "alias/${var.project_name}_kms_alias"
  target_key_id = aws_kms_key.composable_authentication_solution_kms.key_id
}

