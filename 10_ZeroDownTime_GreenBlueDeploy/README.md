# 10 – Highly Available Web Server in Default VPC
This lesson provisions a highly available web infrastructure using Terraform in any AWS region's default VPC.

## Summary
- Automatically finds default subnets in two availability zones
- Dynamically fetches the latest Amazon Linux 2 AMI
- Creates:
  - A Security Group with open ports for HTTP/HTTPS + SSH
  - A Launch Template with user_data
  - An Auto Scaling Group (ASG) across 2 AZs
  - A Classic Load Balancer (ELB) with health checks

## Notes
Uses filebase64() to pass bootstrap script (user_data.sh)