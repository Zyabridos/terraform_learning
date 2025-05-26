output "rds_password" {
  value     = data.aws_ssm_parameter.my_rds_password
  sensitive = true # чтобы выводилась сенсетивная дата, а то Terraform нас от такого пытается уберечь
}