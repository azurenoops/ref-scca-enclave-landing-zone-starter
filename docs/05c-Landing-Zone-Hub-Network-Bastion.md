# Deploy the Landing Zone - Azure Firewall Resource

The following will be created:

* Azure Firewall (main.tf)
* Required Firewall rules (main.tf)

Review and if needed, comment out and modify the variables within the "Landing Zone Configuration" section under "Bastion/Private DNS Zones" of the common variable definitons file [parameters.tfvars](./tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Sample:

```bash

################################
# Landing Zone Configuration  ##
################################

###################################
# 05c Bastion/Private DNS Zones ###
###################################

# Private DNS Zone Settings
# By default, Azure NoOps will create Private DNS Zones for Logging in Hub VNet.
# If you do want to create addtional Private DNS Zones, 
# add in the list of private_dns_zones to be created.
# else, remove the private_dns_zones argument.
hub_private_dns_zones = ["privatelink.file.core.windows.net"]

# By default, this module will create a bastion host, 
# and set the argument to `enable_bastion_host = false`, to disable the bastion host.
enable_bastion_host                 = true
azure_bastion_host_sku              = "Standard"
azure_bastion_subnet_address_prefix = ["10.8.4.192/27"]

```

After Modifying the variables, move on to Landing-Zone-Operations Management Spoke.

### Next step

:arrow_forward: [Deploy the Spoke/LZ Virtual Network](./05d-Landing-Zone-Operations-Spoke-Network.md)
