# 07 – Order of Resource Creation
This lesson shows how to **control the creation order** of resources in Terraform using the `depends_on` attribute.

## Summary
- Without depends_on, Terraform would create all 3 in parallel
- Use this pattern to avoid race conditions, especially for software installation steps (e.g., provisioning, DB schema setup)
