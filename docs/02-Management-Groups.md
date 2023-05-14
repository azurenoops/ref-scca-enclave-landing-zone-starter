# Deploy the Mission Enclave Management Groups

The following will be created:

* Management Groups

Review and if needed, comment out and modify the variables within the "02 Management Groups Configuration" section of the common variable definitons file [parameters.tfvars](./tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Sample:

```bash

########################################
# 02 Management Groups Configuration  ##
########################################

enable_management_groups           = true   # enable management groups for this subscription
root_management_group_id           = "anoa" # the root management group id for this subscription
root_management_group_display_name = "anoa" # the root management group display name for this subscription

# Management groups to create
# The management group structure is created in the locals.tf file

```

Main managment group structure is located in locals.tf. It uses the 'root_management_group_id' for the top level groups. Modify the following to meet your needs.

```terraform
# The following locals are used to define the management groups
locals {
  management_groups = {
    platforms = {
      display_name               = "platforms"
      management_group_name      = "platforms"
      parent_management_group_id = "${local.root_id}"
      subscription_ids           = []
    },
    workloads = {
      display_name               = "workloads"
      management_group_name      = "workloads"
      parent_management_group_id = "${local.root_id}"
      subscription_ids           = []
    },
    sandbox = {
      display_name               = "sandbox"
      management_group_name      = "sandbox"
      parent_management_group_id = "${local.root_id}"
      subscription_ids           = []
    },
    transport = {
      display_name               = "transport"
      management_group_name      = "transport"
      parent_management_group_id = "platforms"
      subscription_ids           = []
    },
    internal = {
      display_name               = "internal"
      management_group_name      = "internal"
      parent_management_group_id = "workloads"
      subscription_ids           = []
    }
    partners = {
      display_name               = "partners"
      management_group_name      = "partners"
      parent_management_group_id = "workloads"
      subscription_ids           = []
    }
  }
}

```

## Deployment

Deployment is done using github actions.  The following steps are for manual deployment.

Navigate to the "/infrastructure/terraform/modules/02-management_groups" directory.

```bash
cd //infrastructure/terraform/modules/02-management_groups
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

After Modifying the variables, move on to deploying the Policy.

### Next step

:arrow_forward: [Deploy the Policy](./03-Policy.md)