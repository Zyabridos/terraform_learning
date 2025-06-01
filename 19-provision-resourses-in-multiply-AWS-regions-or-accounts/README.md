## 19 Provision EC2 in Multiple AWS Regions with Latest Amazon Linux 2 AMIs
This Terraform example provisions 3 EC2 instances across different AWS regions, using the latest Amazon Linux 2 AMIs fetched dynamically from AWS SSM Parameter Store.

## Features
- ```assume_role``` is used in the ```eu-north-1``` provider to operate on behalf of an IAM role from another AWS account.
- Uses multiple provider blocks with aliases (us, ger)
- Retrieves latest AMI for each region using data "aws_ssm_parameter"
Creates EC2 instances in ```eu-north-1``` (Europe North), ```us-east-1``` (US East), ```eu-central-1``` (Germany)

