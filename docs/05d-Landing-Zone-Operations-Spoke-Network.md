# Deploy the Landing Zone - Operations Managmement Spoke Virtual Network

The following will be created:

* Resource Groups for Spoke Networking
* Spoke Networks (Operations)

Review and if needed, comment out and modify the variables within the "Landing Zone Configuration" section under "Operations Management Spoke Virtual Network" of the common variable definitons file [parameters.tfvars](./tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Sample:

```bash

################################
# Landing Zone Configuration  ##
################################

####################################################
# 5d Operations Management Spoke Virtual Network ###
####################################################

ops_name                                       = "ops-core"
ops_vnet_address_space                         = ["10.8.6.0/24"]
ops_subnets                                    = {
  default = {
    name                                       = "ops-core"
    address_prefixes                           = ["10.8.6.224/27"]
    service_endpoints                          = ["Microsoft.Storage"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true
    nsg_subnet_inbound_rules = [
      # [name, description, priority, direction, access, protocol, destination_port_range, source_address_prefixes, destination_address_prefix]
      # Use "" for description to use default description
      # To use defaults, use [""] without adding any value and to use this subnet as a source or destination prefix.      
      ["Allow-Traffic-From-Spokes", "Allow traffic from spokes", "200", "Inbound", "Allow", "*", ["22", "80", "443", "3389"], ["10.8.7.0/24","10.8.8.0/24"], ["10.8.6.0/24"]],
    ]
  }
}
ops_private_dns_zones                          = []
enable_forced_tunneling_on_ops_route_table     = true

```

After Modifying the variables, move on to Landing-Zone-Shared Services Management Spoke.

### Next step

:arrow_forward: [Deploy the Shared Services](./05e-Landing-Zone-Shared-Services-Spoke-Network.md)
