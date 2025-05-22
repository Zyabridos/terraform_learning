output "web_server_instance_id" {
  value = aws_instance.my_webServer.id
}

output "web_server_public_id_address" {
  value = aws_eip.my_static_ip.public_ip
}

output "web_server_public_id_address" {
  value = aws_security_group.my_webServer.id
}

output "web_server_public_id_address" {
  value = aws_security_group.my_webServer.arn
}
