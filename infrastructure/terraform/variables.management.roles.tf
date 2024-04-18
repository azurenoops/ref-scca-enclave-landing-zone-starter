# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

##########################
# Roles Configuration   ##
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