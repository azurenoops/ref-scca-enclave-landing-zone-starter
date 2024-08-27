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
# Identity  ###
#################

variable "deploy_identity_spoke" {
  description = "Deploy the identity spoke."
  type        = bool
  default     = true  
}

variable "id_vnet_address_space" {
  description = "The address space of the identity virtual network."
  type        = list(string)
  default     = ["10.8.6.0/26"]
}

variable "id_subnets" {
  description = "The subnets of the identity virtual network."
  default     = {}
}

variable "enable_forced_tunneling_on_id_route_table" {
  description = "Enables forced tunneling on the identity route table."
  type        = bool
  default     = true
}

variable "id_storage_bypass_ip_cidrs" {
  description = "The IP addresses to bypass for the Identity storage account."
  type        = list(string)
  default    = []  
}

variable "id_storage_account_kind" {
  description = "The kind of the id storage account."
  type        = string
  default     = "StorageV2"
}

variable "id_storage_account_tier" {
  description = "The tier of the id storage account."
  type        = string
  default     = "Standard"
}

variable "id_storage_account_replication_type" {
  description = "The replication type of the id storage account."
  type        = string
  default     = "ZRS"
}