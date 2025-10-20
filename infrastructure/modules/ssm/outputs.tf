
output "parameter_names" {
  value = {
    secret_key           = aws_ssm_parameter.secret_key.name
    debug                = aws_ssm_parameter.debug.name
    db_host              = aws_ssm_parameter.db_host.name
    db_port              = aws_ssm_parameter.db_port.name
    db_name              = aws_ssm_parameter.db_name.name
    db_user              = aws_ssm_parameter.db_user.name
    db_password          = aws_ssm_parameter.db_password.name
    maxmind_account_id   = aws_ssm_parameter.maxmind_account_id.name
    maxmind_license_key  = aws_ssm_parameter.maxmind_license_key.name
  }
}
