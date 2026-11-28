module "network" {
  source = "../modules/network"
  name   = var.account_name
  cidr   = var.vpc_cidr
}

data "aws_caller_identity" "me" {}

output "account" { value = data.aws_caller_identity.me.account_id }
output "vpc_id" { value = module.network.vpc_id }
output "public_ip" { value = module.network.public_ip }