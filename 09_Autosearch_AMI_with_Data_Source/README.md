# 09 – Autosearch AMI with Data Source
This lesson shows how to dynamically fetch the latest AMI for Ubuntu, Amazon Linux 2, and Windows Server using data "aws_ami".

## Summary
- Automatically gets the latest version of each OS (using most_recent = true)
- Avoids hardcoding AMI IDs which can become outdated
- Each AMI is filtered by name, architecture (x86_64), and virtualization type (hvm)
- Ensures that the instances are launched with valid and up-to-date AMIs