output "my_server_ip" {
	value = aws_eip.my_static_ip.public_ip
}

output "my_instance_ip" {
	value = aws_instance.my_server.id
}

output "my_sg_ip" {
	value = aws_security_group.my_server.id
}
