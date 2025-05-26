
variable "env" {
  default = "prod"
}

variable "ec2_size" {
  default = {
    "prod"    = "t3.medium"
    "dev"     = "t3.micro"
    "staging" = "t2.small"
  }
}

variable "prod_owner" {
  default = "Nina Zyabrina"
}

variable "not_prod_owner" {
  default = "Jon Snow"
}

variable "allow_port_list" {
  default = {
    "prod" = ["80", "443"],
    "dev"  = ["80", "443", "8080", "22"]
  }
}