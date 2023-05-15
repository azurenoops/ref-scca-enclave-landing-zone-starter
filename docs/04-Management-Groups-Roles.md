# Deploy the Mission Enclave Management Groups

The following will be created:

* Management Groups

Review and if needed, comment out and modify the variables within the "04 Management Groups Roles Configuration" section of the common variable definitons file [parameters.tfvars](./tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Sample:

```bash

##############################################
# 04 Management Groups Roles Configuration  ##
##############################################

enable_management_groups           = true   # enable management groups for this subscription
root_management_group_id           = "anoa" # the root management group id for this subscription
root_management_group_display_name = "anoa" # the root management group display name for this subscription

# Management groups to create
# The management group structure is created in the locals.tf file

```

After Modifying the variables, move on to Management Hub Virtual Network.

### Next step

:arrow_forward: [Deploy the Landing Zone - Management Hub Virtual Network](./05-Landing-Zone-Hub-Network.md)
