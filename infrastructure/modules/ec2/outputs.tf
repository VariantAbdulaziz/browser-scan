output "ec2_sg_id" {
  value = aws_security_group.ec2_sg.id
}

output "ec2_role_arn" {
  value = aws_iam_role.ec2_role.arn
}

output "ec2_instance_id" {
  value = aws_instance.app_server.id
}

output "app_server_public_ip" {
  value       = aws_instance.app_server.public_ip
  description = "Public IP of the EC2 instance"
}

output "app_server_public_dns" {
  value       = aws_instance.app_server.public_dns
  description = "Public DNS of the EC2 instance"
}

output "app_server_public_url" {
  value       = "https://${aws_instance.app_server.public_dns}"
  description = "Public URL to access app"
}

output "ec2_tags" {
  value = aws_instance.app_server.tags
}
