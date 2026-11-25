provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn     = "arn:aws:iam::${var.account_id}:role/TerraformDeployRole"
    session_name = "tf-${var.account_name}"
  }
  allowed_account_ids = [var.account_id]   # galat account pe ruk jaao
  default_tags {
    tags = { ManagedBy = "terraform", Account = var.account_name, Env = var.env }
  }
}