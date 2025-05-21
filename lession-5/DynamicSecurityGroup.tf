# --------------------------------
# My Terraform 
#
# Build WebServer during Bootstrap
# --------------------------------

provider "aws" {
  region = "eu-north-1"
}

resource "aws_security_group" "my_webServer" {
  name = "Dynamic Security Group"

  dynamic "ingress" {
    for_each = [80, 9092, 443, 8080]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] 
    }
  }

  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.10.0.0/16"] 
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