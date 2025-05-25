# 13 – tfvars & Environment Overrides
This lesson shows how to override default variables using *.tfvars or *.auto.tfvars files, allowing easy switching between environments like development and production.

## Summary
- Variables are defined in variables.tf with sane defaults
- Separate variable files:
  - dev.auto.tfvars for development
  - prod.auto.tfvars for production
- Common tags are reused across all resources using merge()

## Usage
```bash
# Development 
terraform apply -var-file="dev.auto.tfvars"

# Production
terraform apply -var-file="prod.auto.tfvars"
```