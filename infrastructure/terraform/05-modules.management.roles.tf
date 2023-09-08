# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

###########################
### Roles Configuations ###
###########################

module "mod_custom_roles" {
  source                  = "azurenoops/overlays-role-definition/azurerm"
  version                 = "~> 0.1"
  count                   = var.deploy_custom_roles ? 1 : 0
  custom_role_definitions = local.custom_role_definitions # from locals.tf
}