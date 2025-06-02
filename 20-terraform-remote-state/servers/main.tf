provider "aws" {
  region = "eu-north-1"
}

variable "allowed_ports" {
  description = "List of ports to open for Server"
  type        = list(number)
  default     = [80, 443, 22, 8080]
}

terraform {
  backend "s3" {
    bucket = "terraform-project-nina-ziabrina"
    key = "dev/network/terraform.tfstate"
    region = "eu-north-1" 
  }
}

resource "aws_instance" "europe_server" {
  ami           = data.aws_ssm_parameter.ami_eu_north.value
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_server.id]
  subnet_id     = data.terraform_remote_state.network.outputs.public_subnet_ids[0]

  user_data = <<-EOF
    #!/bin/bash
    mkdir -p /var/www/html

    cat <<EOT > /var/www/html/index.html
    <html>
    <h2>Build by Power of Terraform <font color="red">v.0.12</font></h2><br>
    <p>Owner: Nina Ziabrina</p>
    <p>Hello John from Nina</p>
    <p>Hello Masha from Nina</p>
    </html>
    EOT
  EOF

  tags = {
    Name = "Europe Server"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "terraform-project-nina-ziabrina"
    key    = "dev/servers/terraform.tfstate"
    region = "eu-north-1" 
  }
}

resource "aws_security_group" "my_server" {
  name   = "My Security Group"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_ports
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
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Server Security Group"
    Owner = "Nina Ziabrina"
  }
}
