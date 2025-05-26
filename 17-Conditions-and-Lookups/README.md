# 17 - Terraform: Conditional Logic & Lookups

This configuration demonstrates how to use conditional expressions, lookup maps, and dynamic blocks to deploy EC2 instances and security groups depending on the selected environment (dev, prod, staging).  
## What It Does
EC2 Instances
-  ```my_webServer-1```: Uses ```condition ? A : B``` for ```instance_type```
-  ```my_webServer-2```: Uses ```lookup()``` for cleaner size selection
-  ```my_dev_bastion```: Created only if ```env = "dev"``` using ```count```

Security Group
Dynamically opens a list of ports based on environment:
-  ```prod```: ports 80, 443
-  ```dev```: ports 80, 443, 8080, 22
 
## Notes
Bastion host is deployed only in dev for demonstration purposes.
Tags and instance sizes are set automatically per environment.