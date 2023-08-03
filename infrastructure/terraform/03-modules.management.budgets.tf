# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

####################################################
### 03 - Management Group Budgets Configuations  ###
####################################################

module "mod_management_groups_budgets" {
  source = "./modules/03-budgets"

  enable_management_groups_budgets = var.enable_management_groups_budgets
  contact_emails                   = var.budget_contact_emails
  budget_scope                     = module.mod_management_groups.0.management_groups["${local.provider_path.management_groups}${"workloads"}"].id
}
