# 18 Terraform - Loops with count, for, and if

This example demonstrates how to use loops and conditionals in Terraform to create AWS resources dynamically.

## What It Does
- Creates a list of IAM users based on a variable
- Launches 3 EC2 instances with indexed names
Outputs:
- All created users
- User IDs as a list
- Custom greetings with user ARNs
- A map of unique IAM IDs to internal IDs
- Filtered list of users with short names (< 6 characters)
- A map of EC2 instance IDs to their public IPs

## Key Features Used
- count for creating multiple users and instances
- for and if expressions for generating output conditionally
- [*].id syntax for collecting resource attributes
- Map outputs using for expressions