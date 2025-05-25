# 08 – Working with AWS Data Sources

This lesson shows how to use **Terraform Data Sources** to retrieve information about existing AWS infrastructure and use it to create new resources like subnets.

## Data Sources in Use:
- `aws_availability_zones`
- `aws_caller_identity`
- `aws_region`
- `aws_vpcs`
- `aws_vpc` (filtered by tag `Name=prod_vpc`)
- `aws_subnets` (filtered by VPC ID)
- `aws_subnet` (by ID)

## Summary
- Querying AWS metadata and infrastructure
- Creating new subnets based on that metadata
- Using outputs for visibility and reuse