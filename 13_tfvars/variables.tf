variable "region" {
  description = "Please enter AWS region to deploy Server"
  default     = "eu-north-1"
}

variable "instance_type" {
  description = "Enter instance type"
  default     = "t3.micro"
}

variable "allowed_ports" {
  description = "List of ports to open for Server"
  type        = list(number)
  default     = [80, 443, 22, 8080]
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map
  default     = {
    Owner = "Zyabridos"
    Project = "Phoenix"
    CostSenter = "12345"
    Enviorment = "development"
  }
}
