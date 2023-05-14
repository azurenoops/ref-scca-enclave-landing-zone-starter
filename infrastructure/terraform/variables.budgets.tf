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
  default     = ["mpe@microsoft.com"]
}