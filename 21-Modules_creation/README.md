
# AWS VPC Infrastructure Module

This Terraform configuration provisions a fully functional AWS network infrastructure with:

- A Virtual Private Cloud (VPC)
- Internet Gateway for public access
- Multiple public and private subnets across availability zones
- NAT Gateways with Elastic IPs for outbound access from private subnets
- Environment-based configurations (e.g. `dev`, `prod`)

## 🔧 How It Works

### ✅ What gets created:

| Component           | Description |
|--------------------|-------------|
| **VPC**            | A virtual private cloud with a custom CIDR block |
| **Internet Gateway** | Provides internet access to public subnets |
| **Public Subnets** | EC2 instances launched here get public IPs |
| **Private Subnets**| No direct internet access; use NAT to reach internet |
| **NAT Gateway**    | Allows private subnets to reach the internet securely |
| **Elastic IP**     | Assigned to each NAT Gateway |
| **Route Tables**   | Controls routing for public and private subnets |

## 🌍 Environments

The setup supports multiple environments via reusable modules.

### Examples:

```hcl
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
```
### Requirements
---
- Terraform >= 1.3
- AWS credentials configured (e.g. via ~/.aws/credentials or environment variables)

### Notes
---
- Each private subnet gets its own NAT Gateway (for high availability)
- Subnets are distributed across different availability zones
- Public subnets have direct internet access; private ones do not

### Security Best Practices
---
- Never expose private subnets to the internet
- Use security groups and NACLs for fine-grained control
- Restrict NAT gateway usage if unnecessary to reduce cost
