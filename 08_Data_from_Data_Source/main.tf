provider "aws" {}

data "aws_availability_zones" "working"   {} #
data "aws_caller_identity"    "current"   {} # 
data "aws_region"             "current"   {} # в каком регионе расположены сервера (name, description)
data "aws_vpcs"               "my_vpcs"   {} # условные айдишники всех наших серверов, которые сейчас открыты
data "aws_vpc"                "prod_vpc"  {  # пусть мы не значем какой vps у сервера, но значем, что есть tag с названием prod
  filter {
    name            = "tag:Name"             # чувствительно к регистру!
    values          = ["prod_vpc"]
  }
}
data "aws_subnets" "existing" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.prod_vpc.id]
  }
}

resource "aws_subnet" "prod_subnet_1" {
  vpc_id            = data.aws_vpc.prod_vpc.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block        = "172.31.48.0/24"        # уникальный блок
  tags              = {
    Name            = "Subnet-1 in ${data.aws_availability_zones.working.names[0]}"
    Account         = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region          = "${data.aws_region.current.description}"
  }
}

resource "aws_subnet" "prod_subnet_2" {
  vpc_id            = data.aws_vpc.prod_vpc.id
  availability_zone = data.aws_availability_zones.working.names[1]
  cidr_block        = "172.31.64.0/24"      # другой уникальный блок
  tags = {
    Name            = "Subnet-1 in ${data.aws_availability_zones.working.names[1]}"
    Account         = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region          = "${data.aws_region.current.description}"
  }
}


output "data_aws_availability_zones" {
  value = data.aws_availability_zones.working.names
}

output "data_aws_caller_identity" {
  value = data.aws_caller_identity.current.account_id
}

output "data_aws_region_name" {
  value = data.aws_region.current.name
}

output "data_aws_region_description" {
  value = data.aws_region.current.description
}

output "data_aws_vpcs" {
  value = data.aws_vpcs.my_vpcs
}

output "prod_vpc_id" {
  value = data.aws_vpc.prod_vpc.id
}

data "aws_subnet" "existing_1" {
  id = "subnet-096aa7db492bd9c08"
}

data "aws_subnet" "existing_2" {
  id = "subnet-07bdd0b79d57fbf3d"
}

data "aws_subnet" "existing_3" {
  id = "subnet-0d83bd0ff9eed6b03"
}

output "existing_cidrs" {
  value = [
    data.aws_subnet.existing_1.cidr_block,
    data.aws_subnet.existing_2.cidr_block,
    data.aws_subnet.existing_3.cidr_block
  ]
}