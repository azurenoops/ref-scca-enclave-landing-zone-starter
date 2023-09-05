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
# Role Configuration    ##
##########################

variable "deploy_custom_roles" {
  type        = bool
  default     = false
  description = "Specifies whether custom RBAC roles should be created"
}

variable "custom_role_definitions" {
  description = "A list of custom role definitions to be created."
  type        = list(any)
  default     = []
}


