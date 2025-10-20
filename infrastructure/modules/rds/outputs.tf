output "db_endpoint" {
  value = aws_db_instance.django_db.address
}

output "db_port" {
  value = aws_db_instance.django_db.port
}

output "db_name" {
  value = aws_db_instance.django_db.db_name
}

output "db_username" {
  value = aws_db_instance.django_db.username
}

output "db_password" {
  value = aws_db_instance.django_db.password
}
