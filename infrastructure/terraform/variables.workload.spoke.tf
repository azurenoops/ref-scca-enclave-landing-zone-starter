# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

###################################
# Workload Spoke Configuration   ##
###################################

variable "wl_name" {
  description = "A name for the workload spoke. It defaults to wl-core."
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