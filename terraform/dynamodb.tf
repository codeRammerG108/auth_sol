resource "aws_dynamodb_table" "dynamodb_table" {
  name           = "${var.project_name}_SecretsTablePasswordless"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "userNameHash"

 attribute {
    name = "userNameHash"
    type = "B"
  }

  ttl {
    attribute_name = "exp"
    enabled        = true
  }

}