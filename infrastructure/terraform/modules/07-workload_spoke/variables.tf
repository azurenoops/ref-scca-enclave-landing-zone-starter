# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#################################
# Global Configuration
#################################
variable "environment" {
  description = "Name of the environment. This will be used to name the private endpoint resources deployed by this module. default is 'public'"
  type        = string
}

variable "deploy_environment" {
  description = "Name of the workload's environnement (dev, test, prod, etc). This will be used to name the resources deployed by this module. default is 'dev'"
  type        = string
}

variable "org_name" {
  description = "Name of the organization. This will be used to name the resources deployed by this module. default is 'anoa'"
  type        = string
  default     = "anoa"
}

variable "location" {
  type        = string
  description = "If specified, will set the Azure region in which region bound resources will be deployed. Please see: https://azure.microsoft.com/en-gb/global-infrastructure/geographies/"
  default     = "eastus"
}

variable "default_tags" {
  type        = map(string)
  description = "If specified, will set the default tags for all resources deployed by this module where supported."
  default     = {}
}

variable "disable_base_module_tags" {
  type        = bool
  description = "If set to true, will remove the base module tags applied to all resources deployed by the module which support tags."
  default     = false
}

variable "disable_telemetry" {
  type        = bool
  description = "If set to true, will disable telemetry for the module. See https://aka.ms/alz-terraform-module-telemetry."
  default     = false
}

variable "subscription_id_workload" {
  type        = string
  description = "If specified, identifies the Workload subscription for resource deployment."

  validation {
    condition     = can(regex("^[a-z0-9-]{36}$", var.subscription_id_workload)) || var.subscription_id_workload == ""
    error_message = "Value must be a valid Subscription ID (GUID)."
  }
}

#################################
# Resource Lock Configuration
#################################

variable "enable_resource_locks" {
  type        = bool
  description = "If set to true, will enable resource locks for all resources deployed by this module where supported."
  default     = false
}

variable "lock_level" {
  description = "The level of lock to apply to the resources. Valid values are CanNotDelete, ReadOnly, or NotSpecified."
  type        = string
  default     = "CanNotDelete"
}

#################
# Workload    ###
#################

variable "wl_name" {
  description = "A name for the workload. It defaults to wl-core."
  type        = string
  default     = "wl-core"
}

variable "wl_vnet_address_space" {
  description = "The address space of the workload virtual network."
  type        = list(string)
  default     = ["10.8.6.0/26"]
}

variable "wl_subnets" {
  description = "The subnets of the workload virtual network."
  default     = {}
}

variable "is_wl_spoke_deployed_to_same_hub_subscription" {
  description = "Indicates whether the workload spoke is deployed to the same hub subscription."
  type        = bool
  default     = true
}

variable "enable_forced_tunneling_on_wl_route_table" {
  description = "Enables forced tunneling on the workload route table."
  type        = bool
  default     = true
}

variable "wl_private_dns_zones" {
  description = "The private DNS zones of the workload virtual network."
  type        = list(string)
  default     = []
}

variable "use_source_remote_spoke_gateway" {
  description = "Indicates whether to use the source remote spoke gateway."
  type        = bool
  default     = false
}

variable "hub_managmement_logging_log_analytics_id" {
  description = "The Log Analytics resource ID for the hub management logging."
  type        = string
  default     = null
}

variable "hub_managmement_logging_workspace_id" {
  description = "The Log Analytics workspace ID for the hub management logging."
  type        = string
  default     = null
}

variable "enable_traffic_analytics" {
  description = "Enable Traffic Analytics for NSG Flow Logs"
  type        = bool
  default     = false
}