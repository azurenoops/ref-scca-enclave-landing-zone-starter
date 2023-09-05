# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

############################################
### 02 - Management Group Configuations  ###
############################################

# Create Management Groups

module "mod_management_groups" {
  source = "./modules/02-management_groups"
  # Global Configuration
  enable_management_groups           = var.enable_management_groups
  environment                        = var.environment
  root_management_group_id           = var.root_management_group_id
  root_management_group_display_name = var.root_management_group_display_name
  management_groups                  = local.management_groups # from locals.tf
}


