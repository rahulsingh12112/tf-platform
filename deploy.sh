#!/usr/bin/env bash
set -euo pipefail
acct="$1"; action="${2:-plan}"
vars="../accounts/${acct}.tfvars"

cd "$(dirname "$0")/stack"
[ -f "$vars" ] || { echo "Nahi mili: accounts/${acct}.tfvars"; exit 1; }
export TF_DATA_DIR=".terraform-${acct}"

terraform init -reconfigure -input=false -backend-config="key=platform/${acct}/terraform.tfstate"

case "$action" in
  plan)    terraform plan -var-file="$vars" ;;
  apply)   terraform plan -var-file="$vars" -out="${acct}.tfplan"
           terraform apply "${acct}.tfplan"; rm -f "${acct}.tfplan" ;;
  destroy) terraform destroy -var-file="$vars" ;;
  *)       echo "plan | apply | destroy"; exit 1 ;;
esac
