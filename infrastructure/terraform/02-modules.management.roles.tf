# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy Azure Roles for a Hub/Spoke Landing Zone
DESCRIPTION: The following components will be options in this deployment
             * Custom Role Definitions
AUTHOR/S: jrspinella
*/

###########################
### Roles Configurations ##
###########################

module "mod_custom_roles" {
  source                  = "azurenoops/overlays-role-definition/azurerm"
  version                 = "0.1.1"
  count                   = var.deploy_custom_roles ? 1 : 0
  custom_role_definitions = local.custom_role_definitions # from locals.tf
}
