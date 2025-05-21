# --------------------------------
# My Terraform 
#
# Build WebServer during Bootstrap
# --------------------------------

provider "aws" {
  region = "eu-north-1"
}

resource "aws_eip" "my_static_ip" { #aws_eip = aws elastic IP
  instance = aws_instance.my_webServer.id
}

resource "aws_instance" "my_webServer" {
  ami                    = "ami-00f34bf9aeacdf007"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webServer.id]
  user_data              = templatefile("user_data.sh.tpl", {
    first_name = "Nina",
    last_name  = "Ziabrina",
    names      = ["Vasya", "Kolya", "John", "Donald", "Masha"] 
  })

  tags = {
    Name = "Web Server Build by Terraform" # по факту ни на что не влияет, но куда логичнее и красивее задавать имена сервакам
    Owner = "Nina Zyabrina"
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = ["ami", "user_data"]
    create_before_destroy = true
  }
}

resource "aws_security_group" "my_webServer" {
  name = "WebServer Security Group"

  dynamic "ingress" {
    for_each = [80, 9092, 443, 8080]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] 
    }
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