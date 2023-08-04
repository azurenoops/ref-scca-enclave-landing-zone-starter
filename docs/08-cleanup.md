# Cleanup

Remember to destroy resources that are not in use. The instructions below assume your terminal is at the "ref-scca-enclave-starter/infrastructure/terraform". If you are not there navigate there first. Delete in the specified bash below.

Ensure the following state management environment variables have been defined:
- STORAGEACCOUNTNAME = 'xxxxx'
- CONTAINERNAME      = 'xxxxx'
- TFSTATE_RG         = 'xxxxx'

1. Delete the Mission Enclave Landing Zone Starter

   ```bash
   ref-scca-enclave-starter/infrastructure/terraform
   ```

   ```bash
   $STORAGEACCOUNTNAME='xxxxx'
   $CONTAINERNAME='xxxxx'
   $TFSTATE_RG='xxxxx'

   terraform init -backend-config="resource_group_name=$TFSTATE_RG" -backend-config="storage_account_name=$STORAGEACCOUNTNAME" -backend-config="container_name=$CONTAINERNAME"
   ```

   ```bash
   terraform plan -destroy -out anoa.dev.plan --var-file ../tfvars/parameters.tfvars
   ```

   ```bash
   terraform apply anoa.dev.plan
   ```

