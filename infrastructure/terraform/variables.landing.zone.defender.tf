# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
  PARAMETERS
  Here are all the variables a user can override.
*/

################################
# Landing Zone Configuration  ##
################################

#########################
# Defender for Cloud  ###
#########################

variable "enable_defender_for_cloud" {
  description = "Enable Defender for Cloud."
  type        = bool
  default     = true  
}

variable "security_center_pricing_tier" {
  description = "Manages the Pricing Tier for Azure Security Center in the current subscription. Possible values are Free and Standard. NOTE: Changing the pricing tier to Standard affects all resources in the subscription and could be quite costly. Deletion of this resource does not change or reset the pricing tier to Free. Source: https://www.terraform.io/docs/providers/azurerm/r/security_center_subscription_pricing.html"
  type        = string
  default     = "Standard"
}

variable "security_center_pricing_resource_types" {
  description = "List of resource type to apply the Azure Security Center pricing tier. Possible values are Api, AppServices, Arm, CloudPosture, Containers, CosmosDbs, KeyVaults, OpenSourceRelationalDatabases, SqlServers, SqlServerVirtualMachines, StorageAccounts, and VirtualMachines. Source: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/security_center_subscription_pricing#resource_type"
  type        = list(string)
  default     = ["KeyVaults", "StorageAccounts", "VirtualMachines"]
}

variable "security_center_contact_email" {
  description = "The email of the Security Center Contact. https://www.terraform.io/docs/providers/azurerm/r/security_center_contact.html#email"
  type        = string
  default     = null
}

variable "security_center_contact_phone" {
  description = "The phone number of the Security Center Contact. https://www.terraform.io/docs/providers/azurerm/r/security_center_contact.html#phone"
  type        = string
  default     = null
}

variable "security_center_alert_notifications" {
  description = "Whether to send security alerts notifications to the security contact or not. https://www.terraform.io/docs/providers/azurerm/r/security_center_contact.html#alert_notifications"
  type        = bool
  default     = true
}

variable "security_center_alerts_to_admins" {
  description = "Whether to send security alerts notifications to subscription admins or not. https://www.terraform.io/docs/providers/azurerm/r/security_center_contact.html#alerts_to_admins"
  type        = bool
  default     = true
}
