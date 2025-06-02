output "prod_public_subnet_id" {
  value = module.vpc-prod.public_subnets[*].ids
}

output "prod_private_subnet_id" {
  value = module.vpc-prod.private_subnets[*].ids
}

output "development_public_subnet_id" {
  value = module.vpc-dev.public_subnets[*].ids
}

output "development_private_subnet_id" {
  value = module.vpc-dev.private_subnets[*].ids
}