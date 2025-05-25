# 02 – Creating and Updating AWS Resources

This lesson demonstrates how to:

- Create an EC2 web server with `user_data` for Apache installation
- Use `aws_security_group` to open required ports
- Update existing resources (e.g. change `instance_type`)
- Use `count` to launch multiple instances
- Add descriptive `tags` to resources

## Notes
- Use count = N to create multiple EC2 instances.
- Tags improve visibility in the AWS Console.
- Use terraform destroy to clean up everything when you're done.