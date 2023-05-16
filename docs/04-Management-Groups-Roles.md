# Deploy the Mission Enclave Management Groups

The following will be created:

* Management Groups

Review and if needed, comment out and modify the variables within the "04 Management Groups Roles Configuration" section of the common variable definitons file [parameters.tfvars](./tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Sample:

```bash

################################################
# 04 Management Groups Roles Configuration  ##
################################################

deploy_custom_roles = true # true | false

```

Main roles structure is located in locals.tf. It uses the 'data.azurerm_client_config.current.subscription_id' for the scope of the roles. Modify the following to meet your needs.

```terraform

custom_role_definitions = [
  {
    role_definition_name = "Custom - Network Operations (NetOps)"
    scope                = "${data.azurerm_client_config.current.subscription_id}" ## This setting is optional. (If not defined current subscription ID is used).
    description          = "Platform-wide global connectivity management: virtual networks, UDRs, NSGs, NVAs, VPN, Azure ExpressRoute, and others."
    permissions = {
      actions = [
        "Microsoft.Network/virtualNetworks/read",
        "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/read",
        "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/write",
        "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/delete",
        "Microsoft.Network/virtualNetworks/peer/action",
        "Microsoft.Resources/deployments/operationStatuses/read",
        "Microsoft.Resources/deployments/write",
        "Microsoft.Resources/deployments/read"
      ]
      data_actions     = []
      not_actions      = []
      not_data_actions = []
    }
    assignable_scopes = [["${module.mod_management_group.0.management_groups["/providers/Microsoft.Management/managementGroups/platforms"].id}"]] ## This setting is optional. (If not defined current subscription ID is used).
  }
]

```

After Modifying the variables, move on to Management Hub Virtual Network.

### Next step

:arrow_forward: [Deploy the Landing Zone - Management Hub Virtual Network](./05-Landing-Zone-Hub-Network.md)
