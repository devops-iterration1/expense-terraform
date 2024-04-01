env=$1
action=$2

if [ -z "$env" ]; then
  echo "env(dev|qa|prod) is missing"
  exit 1
fi

if [ -z "$tf_action"]; then
  echo "tf_action(apply|destroy) is missing"
fi

rm -rf .terraform/terraform.tfstate
terraform init -backend-config=env-$env/state.tfvars
terraform $action -var-file=env-$env/main.tfvars

