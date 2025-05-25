provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "Server_web" {
 ami = "ami-0c1ac8a41498c1a9c"
 instance_type = "t3.micro"
 vpc_security_group_ids = [aws_security_group.my_webServer.id]

 tags = {
   Name = "Server Web"
 }

 depends_on = [ aws_instance.Server_Database, aws_instance.Server_Application ]
}

resource "aws_instance" "Server_Application" {
 ami = "ami-0c1ac8a41498c1a9c"
 instance_type = "t3.micro"
 vpc_security_group_ids = [aws_security_group.my_webServer.id]
 
 tags = {
  Name = "Server Application"
 }

 depends_on = [ aws_instance.Server_Database ]
}

resource "aws_instance" "Server_Database" {
 ami = "ami-0c1ac8a41498c1a9c"
 instance_type = "t3.micro"
 vpc_security_group_ids = [aws_security_group.my_webServer.id]

 tags = {
   Name = "Server Database"
 }
}

resource "aws_security_group" "my_webServer" {
 name = "My WebServer Security Group"

 dynamic "ingress" {
   for_each = [80, 443, 22]
   content {
     from_port   = ingress.value
     to_port     = ingress.value
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
 }

 egress {
     from_port   = 0 
     to_port     = 0 
     protocol    = "-1"
     cidr_blocks = ["0.0.0.0/0"]
 }
}