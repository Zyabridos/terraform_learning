provider "aws" {
  region = "eu-north-1"
}

module "vpc-xyz" {
  source = "../modules/aws_network"
}

module "vpc-dev" {
  source               = "../modules/aws_network"
  env                  = "development"
  vpc_cidr             = "10.100.0.0/16"
  public_subnet_cidrs  = ["10.100.1.0/24", "10.100.2.0/24"]
  private_subnet_cidrs = ["10.100.11.0/24", "10.100.22.0/24"]
}

module "vpc-prod" {
  source               = "../modules/aws_network"
  env                  = "production"
  vpc_cidr             = "10.10.0.0/16"
  public_subnet_cidrs  = ["10.10.1.0/24", "10.10.2.0/24"]
  private_subnet_cidrs = ["10.100.11.0/24", "10.100.22.0/24"]
}