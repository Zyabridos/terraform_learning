provider "aws" {}

resource "aws_instance" "my_ubuntu" {
  count = 3
  ami = "ami-0c1ac8a41498c1a9c"
  instance_type = "t3.small"

  tags = {
    Name = "My Ubuntu Server"
    Owner = "Zyabridos"
    Project = "Terraform lessions"
  }
}

resource "aws_instance" "my_Amazon" {
  ami = "ami-00f34bf9aeacdf007"
  instance_type = "t3.micro"

  tags = {
    Name = "My Amazon Server"
    Owner = "Zyabridos"
    Project = "Terraform lessions"
  }
}