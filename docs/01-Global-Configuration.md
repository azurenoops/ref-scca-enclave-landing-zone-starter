# Deploy the Mission Enclave Global Configuration

The following will be created:

* Global Configuration

Review and if needed, comment out and modify the variables within the "01 Global Configuration" section of the common variable definitons file [parameters.tfvars](./tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Sample:

```bash

##############################
## 01 Global Configuration  ##
##############################

# The prefixes to use for all resources in this deployment
org_name           = "anoa"   # This Prefix will be used on most deployed resources.  10 Characters max.
deploy_environment = "dev"    # dev | test | prod
environment        = "public" # public | usgovernment

# The default region to deploy to
default_location = "eastus"

# Enable locks on resources
enable_resource_locks = false # true | false

# Enable NSG Flow Logs
# By default, this will enable flow logs traffic analytics for all subnets.
enable_traffic_analytics = true

```

After Modifying the variables, move on to Management Groups.

### Next step

:arrow_forward: [Deploy the Management Groups](./02-Management-Groups.md)