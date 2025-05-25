output "latest_amazon_linux_ami_id" {
  value = data.aws_ami.latest_amazon_linux.id
}

output "latest_amazon_linux_ami_name" {
  value = data.aws_ami.latest_amazon_linux.name
}

output "latest_Ubuntu_ami_id" {
  value = data.aws_ami.latest_Ubuntu.id
}

output "latest_Ubuntu_ami_name" {
  value = data.aws_ami.latest_Ubuntu.name
}

output "latest_Windows_ami_id" {
  value = data.aws_ami.latest_Windows.id
}

output "latest_Windows_ami_name" {
  value = data.aws_ami.latest_Windows.name
}
