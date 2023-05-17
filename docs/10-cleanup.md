# Cleanup

Remember to destroy resources that are not in use. The instructions below assume your terminal is at the "ref-scca-enclave-starter/infrastructure/terraform". If you are not there navigate there first. Delete in the specified bash below.

Ensure the following state management environment variables have been defined:
- STORAGEACCOUNTNAME = 'xxxxx'
- CONTAINERNAME      = 'xxxxx'
- TFSTATE_RG         = 'xxxxx'

1. Delete the Mission Enclave Starter

   ```bash
   ref-scca-enclave-starter/infrastructure/terraform
   ```

   ```bash
   terraform plan -destroy -out me.plan --var-file ../tfvars/parameters.tfvars
   ```

   ```bash
   terraform apply me.plan
   ```

