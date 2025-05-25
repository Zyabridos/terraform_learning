# Autofill parameters for development

# File can be named as:
# terraform.tfvars
# *.auto.tfvars

region        = "ca-centra-1"
instance_type = "t2.micro"

allowed_ports = [80, 443, 22, 8080]

common_tags   = {
  Owner      = "Zyabridos"
  Project    = "Phoenix"
  CostSenter = "12345"
  Enviorment = "development"
}
