# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
  PARAMETERS
  Here are all the variables a user can override.
*/

##########################
# Budget Configuration  ##
##########################

variable "contact_emails" {
  type        = list(string)
  description = "The list of email addresses to be used for contact information for the policy assignments."
}

variable "budget_scope" {
  type        = string
  description = "The scope of the budget. This can be either a subscription, a resource group, or a management group."
}


