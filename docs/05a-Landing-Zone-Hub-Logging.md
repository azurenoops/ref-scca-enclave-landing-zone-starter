# Deploy the Landing Zone - Management Hub OperationL Logging

The following will be created:

* Resource Group for Hub Networking (main.tf)
* Hub Network (main.tf)
* Hub Subnets (main.tf)

Review and if needed, comment out and modify the variables within the "04 Landing Zone Configuration" section under "OperationL Logging" of the common variable definitons file [parameters.tfvars](./tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Sample:

```bash

###################################
# 04 Landing Zone Configuration  ##
###################################

#########################
# OperationL Logging  ###
#########################

# By default, this will module will deploy management logging.
# If you do not want to enable management logging, 
# set enable_management_logging to false.
# All Log solutions are enabled (true) by default. To disable a solution, set the argument to `enable_<solution_name> = false`.
enable_management_logging            = true
log_analytics_workspace_sku          = "PerGB2018"
log_analytics_logs_retention_in_days = 30

```

After Modifying the variables, move on to Hub Firewall.

### Next step

:arrow_forward: [Deploy the Azure Firewall Resource](./05a-Landing-Zone-Hub-Network-Firewall.md)
