
# 16 – Terraform: MySQL RDS with Secure Password via SSM

This Terraform configuration demonstrates how to securely generate, store, and retrieve a MySQL RDS password using:
- random_string for password generation
- AWS SSM Parameter Store for secure storage
- aws_db_instance for RDS creation

  

## What It Does

1. Generates a secure password
A 12-character password is created using the ```random_string``` resource. It updates whenever the ```name``` variable changes, thanks to the ```keepers``` block.

2. Stores the password in AWS SSM Parameter Store
Using the ```SecureString```2 type.

3. Retrieves the password using a ```data``` block
Ensures the password is used safely in other resources (like RDS).
  
4. Provisions a MySQL 8.0 RDS instance
With storage, credentials, and configuration defined via Terraform.

  

## Security Notes

- Password is stored as a ```SecureString``` in AWS Systems Manager (SSM).
- It is never printed unless explicitly output (not recommended).
- For best practice, use ```sensitive = true``` if adding output blocks.