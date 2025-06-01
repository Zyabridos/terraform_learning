// print name of users with, whose name is shorter than 6
output "custom_if_length" {
  value = [
    for x in aws_iam_user.users:
    if length(x.name) < 6
  ]
}

// print nice MAP of Instances: Public ID
output "servers_all" {
  value = {
    for server in aws_instance.servers:
    server.id => server.public_ip
  }
}


output "created_iam_users" {
  value = aws_iam_user.users
}

output "created_iam_users_ids" {
  value = aws_iam_user.users[*].id // * Возьми id всех ресурсов aws_iam_user.users и создай из них список».
}

output "created_iam_users_custom" {
  value = [
    for user in aws_iam_user.users:
    "Hello, user ${user.name}. Has ARN: ${user.arn}"
  ]
}

output "creates_iam_users_map" {
  value = {
    for user in aws_iam_user.users:
    user.unique_id => user.id
  }
}
