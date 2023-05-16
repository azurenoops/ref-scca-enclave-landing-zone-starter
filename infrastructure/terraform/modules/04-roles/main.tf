# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

###########################
### Roles Configuations ###
###########################

module "mod_roles" {
  source  = "azurenoops/overlays-cost-management/azurerm//modules/budgets/managementGroup"
  version = ">= 1.0.0"

  #####################################
  ## Budget Configuration           ###
  #####################################

  budget_name       = "MPE Workloads Budget"
  budget_amount     = 14000
  budget_time_grain = "Monthly"
  budget_category   = "Cost"
  budget_scope      = var.budget_scope
  budget_time_period = {
    start_date = "2023-04-01T00:00:00Z"
    end_date   = "2024-05-01T00:00:00Z"
  }
  budget_notification = [
    {
      enabled        = true
      operator       = "GreaterThan"
      threshold      = 90
      contact_emails = var.contact_emails
    }
  ]
}