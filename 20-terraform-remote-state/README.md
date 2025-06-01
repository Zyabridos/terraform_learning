
# 20 Terraform Project: Multi-layer AWS Infrastructure

This project provisions a basic infrastructure on AWS using **two Terraform layers**:
-   **Layer 1: Network** – creates VPC, public subnets, route tables, and an internet gateway.
-   **Layer 2: Servers** – deploys an EC2 instance using the latest Amazon Linux 2 AMI, referencing the network layer via remote state.
----------

### Structure
```graphql
`20-terraform-remote-state/
├── network/
│   └── main.tf # Creates VPC and networking resources ├── servers/
│   └── main.tf # Creates EC2 instance and security group` 
```
----------

### Requirements

-   AWS CLI configured
    
-   Terraform ≥ 1.3
    
-   S3 bucket for remote backend (e.g., `terraform-project-nina-ziabrina`)
    
-   Proper IAM permissions (optionally with assume_role)
   
----------

### Usage

#### Step 1: Deploy the network layer

bash

КопироватьРедактировать

`cd network
terraform init
terraform apply` 

This will output:

-   `vpc_id`
    
-   `public_subnet_ids`
    

#### Step 2: Deploy the server layer

```bash
cd ../servers
terraform init
terraform apply` 
```
This layer:

-   Reads VPC and subnet IDs from the `network` layer via remote state
    
-   Deploys a `t3.micro` EC2 instance
    
-   Uses the latest Amazon Linux 2 AMI (via AWS SSM Parameter Store)
    
-   Opens allowed ports (80, 443, 22, 8080) via Security Group
    

----------

### Outputs

-   EC2 public IP
    
-   Security Group ID
    
-   Referenced VPC/Subnet IDs (from remote state)
    

----------

### Notes

-   Remote state is stored in the S3 bucket `terraform-project-nina-ziabrina`
    
-   Each layer uses a different key in S3:
    
    -   `dev/network/terraform.tfstate`
        
    -   `dev/servers/terraform.tfstate`
        
-   To destroy infrastructure, run `terraform destroy` in both folders