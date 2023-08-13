# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

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
    subscriptions = "/subscriptions/"
    role_assignment   = "/providers/Microsoft.Authorization/roleAssignments/"
  }
}