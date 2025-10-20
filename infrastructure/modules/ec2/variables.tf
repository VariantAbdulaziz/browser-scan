# VPC and subnet
variable "vpc_id" {
  description = "The VPC ID where EC2 instances will be launched"
  type        = string
}

variable "public_subnet_id" {
  description = "The public subnet ID for the EC2 instance"
  type        = string
}

# Instance configuration
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "EC2 Key pair name for SSH access"
  type        = string
}

# RDS endpoint to connect Django
variable "rds_endpoint" {
  description = "RDS database endpoint"
  type        = string
}

# SSM parameter names for environment variables
variable "ssm_parameter_names" {
  description = "Map of SSM parameter names to fetch environment variables"
  type = object({
    secret_key           = string
    debug                = string
    db_host              = string
    db_port              = string
    db_name              = string
    db_user              = string
    db_password          = string
  })
}

# Optional: AWS region for fetching SSM parameters
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
