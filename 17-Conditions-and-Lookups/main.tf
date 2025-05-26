# --------------------------------
# My Terraform 
#
# Conditions: X = CONDITION ? VALUE_IF_TRUE : VALUE_IF_FALSE
# and
# Lookups   : X = lookup(map, key)

# --------------------------------

provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "my_webServer-1" {
  ami           = "ami-00f34bf9aeacdf007"
  # instance_type = var.env == "prod" ? "t2.large" : "t2.micro"
  instance_type = var.env == "prod" ? var.ec2_size["prod"] : var.ec2_size["dev"]

  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.not_prod_owner
  }
}

resource "aws_instance" "my_webServer-2" {
  ami           = "ami-00f34bf9aeacdf007"
  instance_type = lookup(var.ec2_size, var.env)

  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.not_prod_owner
  }
}

resource "aws_instance" "my_dev_bastion" {
  count         = var.env == "dev" ? 1 : 0
  ami           = "ami-00f34bf9aeacdf007"
  instance_type = var.env == "prod" ? "t2.large" : "t2.micro"

  tags = {
    Name  = "Bastion Server for Dev-server"
    Owner = var.env == "prod" ? var.prod_owner : var.not_prod_owner
  }
}

resource "aws_security_group" "my_webServer" {
  name = "Dynamic Security Group"

  dynamic "ingress" {
    for_each = lookup(var.allow_port_list.var.env)
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