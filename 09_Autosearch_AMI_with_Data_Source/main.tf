# -----------------------------------
# Find latest AMI id of:
#   - Ubuntu
#   - Amazon Linux 2
#   - Windows Server 2025 Base
#
# Made by Nina Ziabrina
# -----------------------------------

provider "aws" {
  region = "eu-north-1"
}

data "aws_ami" "latest_Ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"    # по какому ключу фильтровать
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]      # значение ключа
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

 

data "aws_ami" "latest_Windows" {
  owners      = ["801119661308"]
  most_recent = true
  filter {
    name   = "name"                                                               # по какому ключу фильтровать
    values = ["Windows_Server-2025-English-Full-Base-*"]      # значение ключа
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "my_webServer_ubuntu" {
  ami           = data.aws_ami.latest_Ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "Ubuntu_Server"
  }
}

resource "aws_instance" "my_webServer_Windows" {
  ami           = data.aws_ami.latest_Windows.id
  instance_type = "t3.micro"

  tags = {
    Name = "Windows_Server"
  }
}

resource "aws_instance" "my_webServer_Amazon" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = "t3.micro"

  tags = {
    Name = "Amazon_Server"
  }
}