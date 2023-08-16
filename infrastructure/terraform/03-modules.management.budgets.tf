# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

####################################################
### 03 - Management Group Budgets Configuations  ###
####################################################

module "mod_management_groups_budgets" {
  source = "./modules/03-budgets"

  enable_management_groups_budgets = var.enable_management_groups_budgets
  budget_contact_emails            = var.budget_contact_emails
  budget_amount                    = var.budget_amount
  budget_start_date                = var.budget_start_date
  budget_end_date                  = var.budget_end_date
  budget_scope                     = var.enable_management_groups && var.enable_management_groups_budgets ? module.mod_management_groups.management_groups["${local.provider_path.management_groups}${"workloads"}"].id : null
}
