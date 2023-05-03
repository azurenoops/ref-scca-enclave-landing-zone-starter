# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy an Azure Management Group Hierarchy for a Partner Environment
DESCRIPTION: The following components will be options in this deployment
             * Management Group Hierarchy
AUTHOR/S: jspinella
*/

########################################
###  Management Group Configuations  ###
########################################

module "mod_management_group" {  
  source            = "azurenoops/overlays-management-groups/azurerm"
  version           = "~> 1.0.0"
  root_id           = local.root_id
  root_parent_id    = data.azurerm_subscription.current.tenant_id
  root_name         = local.root_name
  management_groups = local.management_groups
}

resource "time_sleep" "after_azurerm_management_group" {
  depends_on = [
    module.mod_management_group,
  ]
  triggers = {
    "azurerm_management_group" = jsonencode(keys(module.mod_management_group))
  }

  create_duration  = local.create_duration_delay["after_azurerm_management_group"]
  destroy_duration = local.destroy_duration_delay["after_azurerm_management_group"]
}


