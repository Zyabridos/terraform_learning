# Autofill parameters for production

# File can be named as:
# terraform.tfvars
# *.auto.tfvars

region        = "ca-centra-1"
instance_type = "t2.small"

allowed_ports = [80, 443]

common_tags   = {
  Owner      = "Zyabridos"
  Project    = "Phoenix"
  CostSenter = "123477"
  Enviorment = "production"
}
