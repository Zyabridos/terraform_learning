# --------------------------------
# My Terraform 
#
# Build WebServer during Bootstrap
# --------------------------------

provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "my_webServer" {
  ami                    = "ami-00f34bf9aeacdf007" # Amazon Linux AMI
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webServer.id] # приаттачить security group (в скобках указано: достань id`шник данного security group)
  user_data              = file("user_data.sh")

  tags = {
    Name = "Web Server Build by Terraform" # по факту ни на что не влияет, но куда логичнее и красивее задавать имена сервакам
    Owner = "Nina Zyabrina"
  }
}

resource "aws_security_group" "my_webServer" {
  name = "WebServer Security Group"
  description = "My First Security Group"

  ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] # откуда разрешать доступ к порту 80 - нам надо со всего интернета, так что такой блок (= весь интернет)
  }

  # тут у нас будет уходить любой трафик
  egress {
      from_port   = 0 # любой порт
      to_port     = 0 # любой порт
      protocol    = "-1" # любой протокол
      cidr_blocks = ["0.0.0.0/0"] # любой порт
  }

  tags = {
    Name = "Web Server Security Group"
    Owner = "Nina Zyabrina"
  }
}