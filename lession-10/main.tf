# -----------------------------------
# Provision Highly Available Web in any Region Default VPC
# Create:
#   - Security Group for Web Server
#   - Launch Configuration with Auto AMI Lookup
#   - Auto Scaling Group using 2 Avalibility Zones
#   - Classic Load Balancer in 2 Avalibility Zones
#
# Made by Nina Ziabrina
# -----------------------------------

provider "aws" {
  region = "eu-north-1"
}

data "aws_availability_zones" "available" {}

# Default subnets (read from AWS)
data "aws_subnet" "default_az1" {
  filter {
    name   = "availability-zone"
    values = [data.aws_availability_zones.available.names[0]]
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

data "aws_subnet" "default_az2" {
  filter {
    name   = "availability-zone"
    values = [data.aws_availability_zones.available.names[1]]
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20250512.0-x86_64-gp2"]
  }
}

resource "aws_security_group" "web" {
  name = "Dynamicly generated Security Group"

  dynamic "ingress" {
    for_each = [80, 443]
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

resource "aws_launch_template" "web" {
  name_prefix   = "web-template-"
  image_id      = data.aws_ami.latest_amazon_linux.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.web.id]
  user_data              = filebase64("user_data.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name  = "WebServer"
      Owner = "Nina Ziabrina"
    }
  }
}


resource "aws_autoscaling_group" "web" {
  name                      = "WebServer-Highly-Availble-ASG-v2"
  launch_template {
  id      = aws_launch_template.web.id
  version = "$Latest"
  }
  min_size                  = 2 # минимальное колво серверов - если какие-то выходят из строя, то Terraform обязательно запустит другой
  max_size                  = 2

  # min_elb_capacity          = 2 # когда screen group будет знать, что есть 2 хороших готовых сервера - это когда load balancer скажет, что они хорошие
  vpc_zone_identifier       = [data.aws_subnet.default_az1.id, data.aws_subnet.default_az2.id] # в каких subnet`ах можно запускать сервера 
  health_check_type         = "EC2"     # тип health checker`a, который будет слать пинг-запросы на наши сервера 
  load_balancers            = [aws_elb.web.name]

  dynamic "tag" {
    for_each = {
      Name   = "WebServer-in-ASG"
      Owner  = "Nina Ziabrina"
      # TAGKEY = "TAGVALUE"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
      }
    }

    lifecycle {
    create_before_destroy = true
    }
}

resource "aws_elb" "web" { # load balancer
  name               = "WebServer-ON-ELB"
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  security_groups    = [aws_security_group.web.id]
  listener{
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 10
  }
  tags = {
    Name = "WebServer-Highkly-Available-ELB"
  }
}
