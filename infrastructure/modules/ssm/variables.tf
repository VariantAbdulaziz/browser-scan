variable "namespace" {
  description = "Namespace for parameters"
  type        = string
}

variable "secret_key" {
  description = "Django SECRET_KEY"
  type        = string
  sensitive   = true
}

variable "debug" {
  description = "DEBUG mode for Django"
  type        = string
  default     = "False"
}

variable "db_host" {
  description = "Database host"
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "Database port"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database name"
  type        = string
  sensitive   = true
}

variable "db_user" {
  description = "Database username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}


variable "maxmind_account_id" {
  description = "Maxmind account ID"
  type        = string
  sensitive   = true
}

variable "maxmind_license_key" {
  description = "Maxmind License Key"
  type        = string
  sensitive   = true
}

variable "dns_cloudflare_api_token" {
  description = "Cloudflare API Token for certbot"
  type        = string
  sensitive   = true
}