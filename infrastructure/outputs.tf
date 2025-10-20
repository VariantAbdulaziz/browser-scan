output "app_public_ip" {
  value = aws_eip.app_eip.public_ip
}
