# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

################################
### MG Budget Configurations ###
################################

# This module will create a budget in the workloads management group
module "mod_mpe_mg_budgets" {
  source  = "azurenoops/overlays-cost-management/azurerm//modules/budgets/managementGroup"
  version = "~> 1.0"
  count   = var.enable_management_groups_budgets ? 1 : 0 # used in testing

  #####################################
  ## Budget Configuration           ###
  #####################################

  budget_name       = "ANOA Budget"
  budget_amount     = var.budget_amount
  budget_time_grain = "Monthly"
  budget_category   = "Cost"
  budget_scope      = "${local.provider_path.management_groups}workloads"
  budget_time_period = {
    start_date = var.budget_start_date
    end_date   = var.budget_end_date
  }
  budget_notification = [
    {
      enabled        = true
      operator       = "GreaterThan"
      threshold      = 90
      contact_emails = var.budget_contact_emails
    }
  ]
}
