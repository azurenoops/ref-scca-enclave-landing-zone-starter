# Deploy Shared Services

The following will be created:

* Resource Groups for Spoke Networking
* Spoke Networks (Shared Services)

Review and if needed, comment out and modify the variables within the "04 Landing Zone Configuration" section under "Shared Services Management Spoke Virtual Network" of the common variable definitons file [parameters.tfvars](./tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Sample:

```bash

###################################
# 04 Landing Zone Configuration  ##
###################################

######################################################
# Shared Services Management Spoke Virtual Network ###
######################################################

svcs_name                                       = "svcs-core"
svcs_vnet_address_space                         = ["10.8.7.0/24"]
svcs_subnets                                    = {
  default = {
    name                                       = "svcs-core"
    address_prefixes                           = ["10.8.7.224/27"]
    service_endpoints                          = ["Microsoft.Storage"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true
  }
}
svcs_private_dns_zones                          = []
enable_forced_tunneling_on_svcs_route_table     = true
is_svcs_spoke_deployed_to_same_hub_subscription = true

```

After Modifying the variables, move on to deploying the Shared Services.

### Next step

:arrow_forward: [Deploy the Shared Services](./Shared-Services.md)