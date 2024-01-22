variable "existing_kms_key" {
  description = "Id of exsiting KMS key"
  type = string
  default = null
}
variable "project_name" {
  description = "Name of the project"
   type = string
   default = "auth_solution"  
}

variable "allowed_origins" {
  description = "Allowed Origin"
  type = list(string)
  default = []  
}

variable "ses_email" {
  description = "Magic link sender Email"
  type = string
  default = ""
}

variable "log_level" {
  description = "Log Level for console"
  type = string
  default = "DEBUG"
}

variable "aws_region" {
  description = "AWS region"
  type = string
  default = "us-west-2"
}

variable "SALT" {
  description = "Salt Value for updating hash"
  type = string
  default = "ANYNAME2024"
}