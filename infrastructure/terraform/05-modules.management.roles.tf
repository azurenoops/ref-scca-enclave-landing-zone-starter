# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#############################
###  Roles Configuations  ###
#############################

# Roles Hierarchy
module "mod_custom_roles" {
  source = "./modules/04-roles" 
  
  deploy_custom_roles = var.deploy_custom_roles
  custom_role_definitions = local.custom_role_definitions # from locals.tf
}
