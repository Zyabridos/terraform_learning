# 04 – Dynamic Files with `templatefile`

This lesson demonstrates how to generate `user_data` dynamically using the `templatefile()` function and pass variables into the script.

## How to Test
You can test the template without creating resources:
```bash
terraform console
```
Then:

```hcl
templatefile("user_data.sh.tpl", {
  first_name = "Nina",
  last_name  = "Ziabrina",
  names      = ["Vasya", "Kolya", "John", "Donald", "Masha"]
})
```

## Summary
- Use templatefile() to keep .tf files clean
- Templates support variables and loops
- Great for generating startup scripts with dynamic data