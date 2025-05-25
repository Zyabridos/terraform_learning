# -----------------------------------
# My Terraform
#
# Local Variables
#
# -----------------------------------

provider "aws" {
  region = "eu-north-1"
}

data "aws_region" "current" {}
data "aws_availability_zones" "availble" {}

locals {
  full_project_name = "${var.enviorment}-${var.project_name}"
  project_owner     = "${var.owner} owner of ${var.project_name}"
}

locals {
  country = "Canada"
  city    = "Deadmont"
  az_list = join(",", data.aws_availability_zones.availble.names)
} 

resource "aws_eip" "my_static_ip" {
  tags = {
    Name       = "Static IP"
    Owner      = local.project_owner
    Project    = local.full_project_name
    city       = local.city
    region_azs = local.az_list
  }
}