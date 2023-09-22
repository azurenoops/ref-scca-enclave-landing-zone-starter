# Cleanup

Remember to destroy resources that are not in use. If you want to delete an Mission Enclave Landing Zone Starter deployment you can use [`terraform destroy`](https://www.terraform.io/docs/cli/commands/destroy.html). If you have deployed more than one Terraform template, e.g., if you have deployed `landing zone` and then `addon-workload`, run the `terraform destroy` commands in the reverse order that you applied them.

Delete in the specified bash below.

Ensure the following state management environment variables have been defined:

- STORAGEACCOUNTNAME = 'xxxxx'
- CONTAINERNAME      = 'xxxxx'
- TFSTATE_RG         = 'xxxxx'

```bash
# Deploy core MELZS resources
$STORAGEACCOUNTNAME='xxxxx'
$CONTAINERNAME='xxxxx'
$TFSTATE_RG='xxxxx'

terraform init --backend-config="resource_group_name=$TFSTATE_RG" --backend-config="storage_account_name=$STORAGEACCOUNTNAME" --backend-config="container_name=$CONTAINERNAME"

cd infrastructure/terraform
terraform apply --out anoa.dev.plan --var-file ../tfvars/parameters.tfvars --var "subscription_id_hub=<<subscription_id>>" --var "vm_admin_password=<<password>>"

# Destroy core MELZS resources
cd infrastructure/terraform
terraform plan --destroy -out anoa.dev.plan --var-file ../tfvars/parameters.tfvars -var "subscription_id_hub=<<subscription_id>>" --var "vm_admin_password=<<password>>"
terraform apply anoa.dev.plan
```

This command will attempt to remove all the resources that were created by `terraform apply` and could take up to 45 minutes.
