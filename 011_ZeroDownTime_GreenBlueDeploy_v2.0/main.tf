provider "aws" {
  region = "eu-north-1"

  # default_tags будут апплаится на все ресурсы, которые поддерживают default_tags - оч удобно)
  default_tags {
    tags = {
      Owner     = "Nina Ziabrina"
      CreatedBy = "Terraform"
      Course    = "From Zero to Certified Professional"
    }
  }
}
# --------------------------------------------------------------
data "aws_availability_zones" "working" {} # в каких availability zones мы будем использовать

data "aws_ami" "latest_amazon_linux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20250512.0-x86_64-gp2"]
  }
}
# --------------------------------------------------------------
resource "aws_default_vpc" "default" {} # хоть мы и не создаем vpc, но Terraform требует его прописывать

# внутри default vpc нам нужно прописать availability zones, которые мы будем использовать
resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.working.names[0]
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.working.names[1]
}
# --------------------------------------------------------------
# а вот теперь мы создаем наши ресурсы, а не просто прописываем Amazon` овские
# Security Group
resource "aws_security_group" "web" {
  name = "Web Security Group"
  vpc_id = aws_default_vpc.default.id

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
  
  # с серверов все еще может исходить любой трафик
  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  # добавим спецефический тэг, а остальные добавятся через дефолтные
  tags = {
    Name = "Web Server Security Group"
  }
}
# --------------------------------------------------------------
# Launch Template
resource "aws_launch_template" "web" {
  name                   = "WebServer-Highly-Available-LT"
  image_id               = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data              = filebase64("${path.module}/user_data.sh")
}
# --------------------------------------------------------------
# Auto Scaling Group
# так как мы хотим убивать старые сервера и создавать новые, нам надо будет создавать уникальные имена (самый простой способ - через версии)
resource "aws_autoscaling_group" "web" {
  name                      = "WebServer-Highly-Availble-ASG-ver-${aws_launch_template.web.latest_version}"
  min_size                  = 1 # пока сделано так, второй сервер был unhealthy, и поэтому я вообще ни на один из серверов не могла попасть так как не соблюдено условие минимального количества здоровых серверов
  max_size                  = 2
  min_elb_capacity          = 2
  health_check_type         = "ELB"
  vpc_zone_identifier       = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  target_group_arns = [aws_lb_target_group.web.arn]

  launch_template {
    id      = aws_launch_template.web.id
    version = aws_launch_template.web.latest_version
  }
  dynamic "tag" {
    for_each = {
      Name    = "WebServer-in-ASG-v${aws_launch_template.web.latest_version}"
      TAGKEY  = "TAGVALUE"
      Project = "DevOps"
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
# --------------------------------------------------------------
# Load Balancer
resource "aws_lb" "web" {
  name               = "WebServer-HighlyAvailable-ALB"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id] # security group, которую приаттачим к этому load balancer`y
  subnets            = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id] # в каких subnet`ах должен быть задеплоен наш Load Balancer
}
# --------------------------------------------------------------
# Target Group
# Load Balancer не посылает просто так трафик, ему нужен Target Group
resource "aws_lb_target_group" "web" {
  name                 = "WebServer-HighlyAvailable-TG"
  vpc_id               = aws_default_vpc.default.id
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 10 # seconds
}
# --------------------------------------------------------------
# Listener
# На Load Balancer нужно создавать Listener - на каком порту этот load balancer слушать и правила (роутинг и трафик)
# Например, получи трафик на 80 порту, и потом куда его направить 
# Получи трафик с 80 порта
resource "aws_lb_listener" "http" {
  load_balancer_arn    = aws_lb.web.arn
  port                 = 80
  protocol             = "HTTP"

  # что делать - зафорвардить весь трафик в target группу с именем "web"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}
# --------------------------------------------------------------
output "web_loadbalancer_url" {
  value = aws_lb.web.dns_name
}