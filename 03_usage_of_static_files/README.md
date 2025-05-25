# 03 – Using Static Files for `user_data`

This lesson shows how to use an external static file for bootstrapping an EC2 instance with a web server.  
Instead of embedding the shell script directly in Terraform code, we reference a separate `user_data.sh` file using the `file()` function.

## Summary
- External scripts help keep Terraform files clean
- Easy to reuse across modules and projects
- Better readability and separation of concerns
