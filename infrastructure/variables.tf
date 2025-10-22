variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "eu-north-1"
}

variable "namespace" {
  description = "Namespace for Resources"
  type        = string
  default     = "<app-name>"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet (RDS)"
  type        = string
  default     = "10.0.2.0/24"
}

variable "instance_type" {
  description = "EC2 instance type for Django application"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "EC2 key pair name for SSH access"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "django_db"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "django_user"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "Django SECRET_KEY"
  type        = string
  sensitive   = true
}

variable "debug" {
  description = "DEBUG mode for Django"
  type        = string
  default     = "True"
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