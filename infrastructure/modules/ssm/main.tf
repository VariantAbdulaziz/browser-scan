# Django SECRET_KEY
resource "aws_ssm_parameter" "secret_key" {
  name  = "/${var.namespace}/SECRET_KEY"
  type  = "SecureString"
  value = var.secret_key
}

# DEBUG variable (optional)
resource "aws_ssm_parameter" "debug" {
  name  = "/${var.namespace}/DEBUG"
  type  = "String"
  value = var.debug
}

# Database Host
resource "aws_ssm_parameter" "db_host" {
  name  = "/${var.namespace}/DB_HOST"
  type  = "SecureString"
  value = var.db_host
}

# Database Port
resource "aws_ssm_parameter" "db_port" {
  name  = "/${var.namespace}/DB_PORT"
  type  = "SecureString"
  value = var.db_port
}

# Database Name
resource "aws_ssm_parameter" "db_name" {
  name  = "/${var.namespace}/DB_NAME"
  type  = "SecureString"
  value = var.db_name
}

# Database Username
resource "aws_ssm_parameter" "db_user" {
  name  = "/${var.namespace}/DB_USER"
  type  = "SecureString"
  value = var.db_user
}

# Database Password
resource "aws_ssm_parameter" "db_password" {
  name  = "/${var.namespace}/DB_PASSWORD"
  type  = "SecureString"
  value = var.db_password
}

# Maxmind Account Id
resource "aws_ssm_parameter" "maxmind_account_id" {
  name  = "/${var.namespace}/MAXMIND_ACCOUNT_ID"
  type  = "SecureString"
  value = var.maxmind_account_id
}

# Maxmind Licence Key
resource "aws_ssm_parameter" "maxmind_license_key" {
  name  = "/${var.namespace}/MAXMIND_LICENSE_KEY"
  type  = "SecureString"
  value = var.maxmind_license_key
}

resource "aws_ssm_parameter" "dns_cloudflare_api_token" {
  name  = "/${var.namespace}/DNS_CLOUDFLARE_API_TOKEN"
  type  = "SecureString"
  value = var.dns_cloudflare_api_token
}
