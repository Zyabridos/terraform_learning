# --------------------------------
# My Terraform 
#
# Terraform loops: Count and for if
# 
# --------------------------------

variable "aws_users" {
  description = "List of IAM Users to create"
  default = ["Dostoevslky", "Pushkin", "Lermontov", "Kafka", "Sartr"]
}
provider "aws" {
  region = "eu-north-1"
}

resource "aws_iam_user" "users" {
  count = length(var.aws_users)
  name  = element(var.aws_users, count.index)
}

resource "aws_instance" "servers" {
  count         = 3
  ami           = "amzn2-ami-kernel-5.10-hvm-2.0.20250512.0-x86_64-gp2"
  instance_type = "t3.micro"
  tags   = {
    Name = "Server number ${count.index + 1}"
  }
}
