# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
  PARAMETERS
  Here are all the variables a user can override.
*/

################################
# Landing Zone Configuration  ##
################################

#################
# Operations  ###
#################

variable "ops_vnet_address_space" {
  description = "The address space of the operations virtual network."
  type        = list(string)
  default     = ["10.8.6.0/26"]
}

variable "ops_subnets" {
  description = "The subnets of the operations virtual network."
  default     = {}
}

variable "enable_forced_tunneling_on_ops_route_table" {
  description = "Enables forced tunneling on the operations route table."
  type        = bool
  default     = true
}

variable "ops_storage_bypass_ip_cidrs" {
  description = "The IP addresses to bypass for the Operations storage account."
  type        = list(string)
  default    = []  
}

variable "ops_storage_account_kind" {
  description = "The kind of the operations storage account."
  type        = string
  default     = "StorageV2"
}

variable "ops_storage_account_tier" {
  description = "The tier of the operations storage account."
  type        = string
  default     = "Standard"
}

variable "ops_storage_account_replication_type" {
  description = "The replication of the operations storage account."
  type        = string
  default     = "ZRS"
}