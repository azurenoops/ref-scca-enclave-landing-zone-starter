# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy an Azure Partner Environment
DESCRIPTION: The following components will be options in this deployment
             * Management Group Hierarchy
AUTHOR/S: jspinella
*/

########################################
###  Management Group Configuations  ###
########################################

module "mod_management_groups" {
  source = "./modules/management_groups"
  count  = var.enable_management_groups ? 1 : 0 # used in testing

  # Global Configuration
  root_management_group_id           = local.root_id
  root_management_group_display_name = local.root_name
  management_groups                  = local.management_groups  
}

module "mod_management_groups_budgets" {
  source = "./modules/budgets"
  count  = var.enable_management_groups_budgets ? 1 : 0 # used in testing

  contact_emails = var.budget_contact_emails
  budget_scope   = module.mod_management_groups.0.management_groups["${local.provider_path.management_groups}${"workloads"}"].id
}