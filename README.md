# Terraform Learning Journey
This repository documents my step-by-step progress in learning Terraform.
All lessons were **written manually** based on external materials — I used them as guidance only, not as a source for direct copy-paste.

## 🎓Credits

Special thanks to [Denis from ADV-IT](https://www.youtube.com/@ADV-IT) for his excellent Terraform tutorials.  
His clear explanations and structured approach played a big role in helping me understand key concepts and build confidence on my path toward becoming a DevOps Engineer.

## Skills covered

- Providers, resources, and variables
- Dynamic blocks and expressions
- Modules and workspaces
- Remote state & locking
- Provisioners & `user_data`
- LifeCycle rules (e.g. `create_before_destroy`)
- Auto Scaling Groups, Load Balancers
- Outputs and interpolations
- More are coming...

## This repo serves as:
- My personal study log
- A reference for common Terraform patterns
- A supplement to [my real-world project](https://github.com/Zyabridos/terraform-project)


### Set AWS Credentials in Windows PowerShell:
```
$env:AWS_ACCESS_KEY_ID="xxxxxxxxxxxxxxxxx"
$env:AWS_SECRET_ACCESS_KEY="yyyyyyyyyyyyyyyyyyyyyyyyyyyy"
$env:AWS_DEFAULT_REGION="zzzzzzzzz"
```

### Set AWS Credentials in Linux Shell:
```
export AWS_ACCESS_KEY_ID="xxxxxxxxxxxxxxxxx"
export AWS_SECRET_ACCESS_KEY="yyyyyyyyyyyyyyyyyyyyyyyyyyyy"
export AWS_DEFAULT_REGION="zzzzzzzzz"
```
### Terraform Commands
```
terraform init
terraform plan
terraform apply
terraform destroy

terraform show
terraform output
terraform console
terraform import
terraform taint
```
### Terraform State Commands
```
terraform state show
terraform state list
terraform state pull
terraform state rm
terraform state mv
terraform state push
```
`for x in $(terraform state list | grep xyz); do terraform state mv -state-out=”terraform.tfstate” $x $x; done`

### Terraform Workspace Commands
```
terraform workspace show
terraform workspace list
terraform workspace new
terraform workspace select
terraform workspace delete
```
