# 11 – Highly Available WebServer with ALB and Auto Scaling
This lesson demonstrates how to build a resilient web infrastructure with Terraform, using Application Load Balancer and Auto Scaling Group across two availability zones in a default VPC.

## Summary
- Uses aws_default_vpc and aws_default_subnet to work in any AWS region without creating custom networking
- Automatically finds latest Amazon Linux 2 AMI
- Resources created:
  - Security Group with dynamic ports
  - Launch Template with embedded user_data
  - Auto Scaling Group (ASG) in 2 zones
  - Application Load Balancer (ALB) with a Target Group and Listener
  - Load balancer URL exposed via output

## Notes
- create_before_destroy ensures smoother updates in ASG
- min_elb_capacity = 2 can block health check if one instance becomes unhealthy
- user_data script must be base64-encoded