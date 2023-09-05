# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

##########################
# Global Configuration  ##
##########################
variable "environment" {
  description = "Name of the environment. This will be used to name the private endpoint resources deployed by this module. default is 'public'"
  type        = string
}

##########################
# Budget Configuration  ##
##########################

variable "enable_management_groups_budgets" {
  type        = bool
  description = "Enable the management groups budgets module."
  default     = false
}

variable "budget_contact_emails" {
  type        = list(string)
  description = "The list of email addresses to be used for contact information for the policy assignments."
  default     = null
}

variable "budget_amount" {
  type        = number
  description = "The amount of the budget."
  default     = null
}

variable "budget_scope" {
  type        = string
  description = "The scope of the budget. This can be either a subscription, a resource group, or a management group."
  default     = null
}

variable "budget_start_date" {
  type        = string
  description = "The start date of the budget."
  default     = null
}

variable "budget_end_date" {
  type        = string
  description = "The end date of the budget."
  default     = null
}


