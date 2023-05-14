# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy an Azure Budgets for a Partner Environment
DESCRIPTION: The following components will be options in this deployment
             * Budgets
AUTHOR/S: jspinella
*/

###############################
### MG Budget Configuations ###
###############################

# This module will create a budget in the workloads management group
module "mod_mpe_mg_budgets" {
  source  = "azurenoops/overlays-cost-management/azurerm//modules/budgets/managementGroup"
  version = ">= 1.0.0"

  #####################################
  ## Budget Configuration           ###
  #####################################

  budget_name       = "MPE Workloads Budget"
  budget_amount     = var.budget_amount
  budget_time_grain = "Monthly"
  budget_category   = "Cost"
  budget_scope      = var.budget_scope
  budget_time_period = {
    start_date = var.budget_start_date
    end_date   = var.budget_end_date
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