# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# The following block of locals are used to avoid using
# empty object types in the code
locals {
  empty_list   = []
  empty_map    = tomap({})
  empty_string = ""
}

# The following locals are used to define the service endpoints
locals {
  fw_service_endpoints = var.environment == "public" ? [
    "Microsoft.ActiveDirectory",
    "Microsoft.AzureCosmosDB",
    "Microsoft.EventHub",
    "Microsoft.KeyVault",
    "Microsoft.ServiceBus",
    "Microsoft.Sql",
    "Microsoft.Storage",
  ] : [
    "Microsoft.AzureCosmosDB",
    "Microsoft.EventHub",
    "Microsoft.KeyVault",
    "Microsoft.ServiceBus",
    "Microsoft.Sql",
    "Microsoft.Storage",
  ]
}

# The following locals are used to define a set of module
# tags applied to all resources unless disabled by the
# input variable "disable_module_tags" and prepare the
# tag blocks for each sub-module
locals {
  base_module_tags = {
    deployedBy = "AzureNoOpsTF"
  }
  hub_resources_tags = merge(
    var.disable_base_module_tags ? local.empty_map : local.base_module_tags,
    var.default_tags,
  )
  identity_resources_tags = merge(
    var.disable_base_module_tags ? local.empty_map : local.base_module_tags,
    var.default_tags,
  )
  operations_resources_tags = merge(
    var.disable_base_module_tags ? local.empty_map : local.base_module_tags,
    var.default_tags,
  )
  devsecops_resources_tags = merge(
    var.disable_base_module_tags ? local.empty_map : local.base_module_tags,
    var.default_tags,
  )
  security_resources_tags = merge(
    var.disable_base_module_tags ? local.empty_map : local.base_module_tags,
    var.default_tags,
  )
}

# The following locals are used to define the management groups
locals {
  management_groups = {
    platforms = {
      display_name               = "platforms"
      management_group_name      = "platforms"
      parent_management_group_id = "${var.root_management_group_id}"
      subscription_ids           = []
    },
    workloads = {
      display_name               = "workloads"
      management_group_name      = "workloads"
      parent_management_group_id = "${var.root_management_group_id}"
      subscription_ids           = []
    },
    sandbox = {
      display_name               = "sandbox"
      management_group_name      = "sandbox"
      parent_management_group_id = "${var.root_management_group_id}"
      subscription_ids           = []
    },
    transport = {
      display_name               = "transport"
      management_group_name      = "transport"
      parent_management_group_id = "platforms"
      subscription_ids           = ["${var.subscription_id_hub}"]
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

# The following locals are used to define roles for the subscriptions
locals {
  custom_role_definitions = [
    {
      role_definition_name = "Custom - Network Operations (NetOps)"
      description          = "Platform-wide global connectivity management: virtual networks, UDRs, NSGs, NVAs, VPN, Azure ExpressRoute, and others."
      scope                = "${local.provider_path.subscriptions}${var.subscription_id_hub}"
      permissions = {
        actions = [
          "*/read",
          "Microsoft.Network/*",
          "Microsoft.Resources/deployments/*",
          "Microsoft.Support/*"
        ]
        data_actions     = []
        not_actions      = []
        not_data_actions = []
      }
      assignable_scopes = ["${local.provider_path.subscriptions}${var.subscription_id_hub}"] ## This setting is optional. (If not defined current subscription ID is used).
    },
    {
      role_definition_name = "Custom - Security Operations (SecOps)"
      description          = "Platform-wide global security management: Security administrator role with a horizontal view across the entire Azure estate and the Azure Key Vault purge policy"
      scope                = "${local.provider_path.subscriptions}${var.subscription_id_hub}"
      permissions = {
        actions = [
          "*/read",
          "*/register/action",
          "Microsoft.KeyVault/locations/deletedVaults/purge/action",
          "Microsoft.PolicyInsights/*",
          "Microsoft.Authorization/policyAssignments/*",
          "Microsoft.Authorization/policyDefinitions/*",
          "Microsoft.Authorization/policyExemptions/*",
          "Microsoft.Authorization/policySetDefinitions/*",
          "Microsoft.Insights/alertRules/*",
          "Microsoft.Resources/deployments/*",
          "Microsoft.Security/*",
          "Microsoft.Support/*"
        ]
        data_actions     = []
        not_actions      = []
        not_data_actions = []
      }
      assignable_scopes = ["${local.provider_path.subscriptions}${var.subscription_id_hub}"] ## This setting is optional. (If not defined current subscription ID is used).
    }
  ]
}

# The following locals are used to define base Azure
# provider paths and resource types
locals {
  provider_path = {
    management_groups = "/providers/Microsoft.Management/managementGroups/"
    subscriptions     = "/subscriptions/"
    role_assignment   = "/providers/Microsoft.Authorization/roleAssignments/"
  }
}

# The following locals are Private DNS resource ids
locals {
  blob_pdns_id = "${local.provider_path.subscriptions}${var.subscription_id_hub}/resourceGroups/${module.mod_hub_network.private_dns_zone_resource_group_name}/providers/Microsoft.Network/privateDnsZones/${var.environment == "public" ? "privatelink.blob.core.windows.net" : "privatelink.blob.core.usgovcloudapi.net"}"
  vault_pdns_id = "${local.provider_path.subscriptions}${var.subscription_id_hub}/resourceGroups/${module.mod_hub_network.private_dns_zone_resource_group_name}/providers/Microsoft.Network/privateDnsZones/${var.environment == "public" ? "privatelink.vaultcore.azure.net" : "privatelink.vaultcore.usgovcloudapi.net"}"
  ampls_agentsvc_id = "${local.provider_path.subscriptions}${var.subscription_id_hub}/resourceGroups/${module.mod_hub_network.private_dns_zone_resource_group_name}/providers/Microsoft.Network/privateDnsZones/${var.environment == "public" ? "privatelink.agentsvc.azure-automation.net" : "privatelink.agentsvc.azure-automation.us"}"
  ampls_monitor_id = "${local.provider_path.subscriptions}${var.subscription_id_hub}/resourceGroups/${module.mod_hub_network.private_dns_zone_resource_group_name}/providers/Microsoft.Network/privateDnsZones/${var.environment == "public" ? "privatelink.monitor.azure.com" : "privatelink.monitor.azure.us"}"
  ampls_ods_id = "${local.provider_path.subscriptions}${var.subscription_id_hub}/resourceGroups/${module.mod_hub_network.private_dns_zone_resource_group_name}/providers/Microsoft.Network/privateDnsZones/${var.environment == "public" ? "privatelink.ods.opinsights.azure.com" : "privatelink.ods.opinsights.azure.us"}"
  ampls_oms_id = "${local.provider_path.subscriptions}${var.subscription_id_hub}/resourceGroups/${module.mod_hub_network.private_dns_zone_resource_group_name}/providers/Microsoft.Network/privateDnsZones/${ var.environment == "public" ? "privatelink.oms.opinsights.azure.com" : "privatelink.oms.opinsights.azure.us"}"
}

# The following locals are used to control time_sleep
# delays between resources to reduce transient errors
# relating to replication delays in Azure
locals {
  create_duration_delay = {
    after_azurerm_management_group = var.create_duration_delay["azurerm_management_group"]
  }
  destroy_duration_delay = {
    after_azurerm_management_group = var.destroy_duration_delay["azurerm_management_group"]
  }
}
