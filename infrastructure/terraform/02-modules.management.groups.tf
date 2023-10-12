# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy an Azure Management Group Hierarchy for a Partner Environment
DESCRIPTION: The following components will be options in this deployment
             * Management Group Hierarchy
AUTHOR/S: jrspinella
*/

########################################
###  Management Group Configurations  ###
########################################

module "mod_management_group" {
  source            = "azurenoops/overlays-management-groups/azurerm"
  version           = "~> 1.0"
  count             = var.enable_management_groups ? 1 : 0 # used in testing
  root_id           = var.root_management_group_id
  root_parent_id    = data.azurerm_client_config.root.tenant_id
  root_name         = var.root_management_group_display_name
  management_groups = local.management_groups
}

resource "time_sleep" "after_azurerm_management_group" {
  depends_on = [
    module.mod_management_group,
  ]
  triggers = {
    "azurerm_management_group" = length(module.mod_management_group) > 0 ? jsonencode(keys(module.mod_management_group[0])) : null
  }

  create_duration  = local.create_duration_delay["after_azurerm_management_group"]
  destroy_duration = local.destroy_duration_delay["after_azurerm_management_group"]
}

