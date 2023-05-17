# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

###########################
### Roles Configuations ###
###########################

module "mod_custom_roles" {
  source                  = "azurenoops/overlays-role-definition/azurerm"
  version                 = ">= 0.1.0"
  count                   = var.deploy_custom_roles == true ? 1 : 0
  custom_role_definitions = var.custom_role_definitions
}