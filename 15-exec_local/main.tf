provider "aws" {
  region = "eu-north-1"
}

resource "null_resource" "command1" {
  provisioner "local-exec" {
    command = "echo Terraform START: $(date) >> log.txt"
  }
}

resource "null_resource" "command2" {
  provisioner "local-exec" {
    command = "ping -c 5 www.google.com" # пингануть google.com 5 раз
  }
}

resource "null_resource" "command3" {
  provisioner "local-exec" {
    # command   = "python3 -c '('Hello, world!')'" можно так, а можно красивее
    command     = "print('Hello, world!')"
    interpreter = [ "python3", "-c" ] # или прописать полный путь к Питону
  }
}

resource "null_resource" "command4" {
  provisioner "local-exec" {
    command     = "echo $NAME1 $NAME2 $NAME3 >> names.txt"
    environment = {
      NAME1 = "Vasya"
      NAME2 = "Kolya"
      NAME3 = "Petya"
    }
  }
}

resource "aws_instance" "myserver" {
  ami           = "ami-00f34bf9aeacdf007"
  instance_type = "t3.micro"
  provisioner "local-exec" {
    command = "echo Hello from AWS Instance Creations!"
  }
}

resource "null_resource" "command6" {
  provisioner "local-exec" {
    command = "echo Terraform END: $(date) >> log.txt"
  }
  depends_on = [ null_resource.command1, null_resource.command2, null_resource.command3, null_resource.command4, aws_instance.myserver ]
}