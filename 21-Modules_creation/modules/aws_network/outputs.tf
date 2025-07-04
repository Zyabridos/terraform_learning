output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "public_subnet_id" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnets[*].id
}