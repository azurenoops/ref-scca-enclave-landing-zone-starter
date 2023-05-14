# Deploy the Mission Enclave Policy

The following will be created:

* Policy Definitions
* Policy Assignments

Review and if needed, comment out and modify the variables within the "Landing Zone" section of the common variable definitons file [parameters.tfvars](./tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Sample:

```bash

##################################################
## 02 Hub Virtual Network
##################################################
    # hub_vnet_addr_prefix           = "10.0.0.0/16"
    # azurefw_addr_prefix            = "10.0.1.0/24"
    # azurebastion_addr_prefix       = "10.0.0.0/24"

```

Navigate to the "/infrastructure/modules/landingzone" directory.

```bash
cd /infrastructure/modules/landingzone
```
Deploy using Terraform Init, Plan and Apply

```bash

# Ensure the following state management runtime variables have been defined:
#   STORAGEACCOUNTNAME = 'xxxxx'
#   CONTAINERNAME      = 'xxxxx'
#   TFSTATE_RG         = 'xxxxx'



terraform init -backend-config="resource_group_name=$TFSTATE_RG" -backend-config="storage_account_name=$STORAGEACCOUNTNAME" -backend-config="container_name=$CONTAINERNAME"
```

```bash
terraform plan -out test.plan --var-file ../tfvars/parameters.tfvars
```

```bash
terraform apply test.plan
```

After Modifying the variables, move on to deploying the Shared Services.

### Next step

:arrow_forward: [Deploy the Shared Services](./Shared-Services.md)