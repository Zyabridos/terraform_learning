provider "aws" {
  region = "eu-north-1"
}

variable "name" {
  default = "Vasya"
}

# генерация пароля
resource "random_string" "rds_password" {
  length           = 12
  special          = true
  override_special = "!_*"
  keepers          = {
    keeper1 = var.name # сгенерируй новый пароль для random_string.rds_password каждый раз, когда меняется значение переменной name
    # keeperrr2 = var.something
  }
}

# хранение пароля
resource "aws_ssm_parameter" "rds_password" {
  name        = "/prod/mysql"
  description = "Master password for RDB MySQL"
  type        = "SecureString"
  value       = random_string.rds_password.result # result - это все, что возращает ресурс random_string.red_password
}

# взять пароль с сервера
data "aws_ssm_parameter" "my_rds_password" {
  name = "/prod/mysql"
  depends_on = [ aws_ssm_parameter.rds_password ] # не забудем подождать его создания 
}

# создадим простенькую БД
resource "aws_db_instance" "default" {
  # название ДБ
  identifier           = "prod-rds"
  allocated_storage    = 10
  db_name              = "prod"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "Zyabridos"
  password             = data.aws_ssm_parameter.my_rds_password.value
  parameter_group_name = "default.mysql8.0"
  # чтобы не делать snapshot`ы при удалении БД
  skip_final_snapshot  = true
  apply_immediately    = true
}