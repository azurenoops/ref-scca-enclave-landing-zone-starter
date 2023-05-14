# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
  PARAMETERS
  Here are all the variables a user can override.
*/

###############################
# Key Vault Configuration   ##
###############################

variable "enabled_for_deployment" {
  description = "Whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the Key Vault."
  type        = bool
  default     = false
}

variable "enabled_for_disk_encryption" {
  description = "Whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys."
  type        = bool
  default     = false
}

variable "enabled_for_template_deployment" {
  description = "Whether Azure Resource Manager is permitted to retrieve secrets from the Key Vault."
  type        = bool
  default     = false
}

variable "admin_group_name" {
  description = "The name of the group to be given access to the Key Vault."
  type        = string
}