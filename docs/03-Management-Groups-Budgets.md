# Deploy the Mission Enclave Management Groups

The following will be created:

* Management Groups

Review and if needed, comment out and modify the variables within the "02 Management Groups Configuration" section of the common variable definitons file [parameters.tfvars](./tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Sample:

```bash

################################################
# 03 Management Groups Budgets Configuration  ##
################################################

# Budgets for management groups
enable_management_groups_budgets = false  # enable budgets for management groups
budget_contact_emails   

```

After Modifying the variables, move on to Management Groups Roles.

### Next step

:arrow_forward: [Deploy the Management Groups Roles](./04-Management-Groups-Roles.md)