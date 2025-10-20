provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}

module "rds" {
  source             = "./modules/rds"
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  ec2_sg_id          = module.ec2.ec2_sg_id
}

module "ssm" {
  source    = "./modules/ssm"
  namespace = var.namespace

  secret_key = var.secret_key
  debug      = var.debug

  db_host     = module.rds.db_endpoint
  db_port     = module.rds.db_port
  db_name     = module.rds.db_name
  db_user     = module.rds.db_username
  db_password = module.rds.db_password
}

module "ec2" {
  source              = "./modules/ec2"
  vpc_id              = module.vpc.vpc_id
  public_subnet_id    = module.vpc.public_subnet_ids[0]
  rds_endpoint        = module.rds.db_endpoint
  ssm_parameter_names = module.ssm.parameter_names
  key_name            = var.key_name
  instance_type       = var.instance_type
}

module "codedeploy" {
  source       = "./modules/codedeploy"
  ec2_role_arn = module.ec2.ec2_role_arn
  namespace    = var.namespace
  ec2_tags     = module.ec2.ec2_tags
}

resource "aws_eip" "app_eip" {
  instance = module.ec2.ec2_instance_id
}
