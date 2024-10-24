# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
  PARAMETERS
  Here are all the variables a user can override.
*/

################################
# Landing Zone Configuration  ##
################################

###############
# Security  ###
###############

variable "security_name" {
  description = "A name for the security. It defaults to security."
  type        = string
  default     = "security"
}

variable "security_vnet_address_space" {
  description = "The address space of the security virtual network."
  type        = list(string)
  default     = ["10.8.6.0/26"]
}

variable "security_subnets" {
  description = "The subnets of the security virtual network."
  type = map(object({
    #Basic info for the subnet
    name                                       = string
    address_prefixes                           = list(string)
    service_endpoints                          = list(string)
    private_endpoint_network_policies_enabled  = string
    private_endpoint_service_endpoints_enabled = bool

    # Delegation block - see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet#delegation
    delegation = optional(object({
      name = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    }))

    #Subnet NSG rules - see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group#security_rule
    nsg_subnet_rules = optional(map(object({
      name                                       = string
      description                                = string
      priority                                   = number
      direction                                  = string
      access                                     = string
      protocol                                   = string
      source_port_range                          = optional(string)
      source_port_ranges                         = optional(list(string))
      destination_port_range                     = optional(string)
      destination_port_ranges                    = optional(list(string))
      source_address_prefix                      = optional(string)
      source_address_prefixes                    = optional(list(string))
      source_application_security_group_ids      = optional(list(string))
      destination_address_prefix                 = optional(string)
      destination_address_prefixes               = optional(list(string))
      destination_application_security_group_ids = optional(list(string))
    })))
  }))
  default = {}
}

variable "enable_forced_tunneling_on_security_route_table" {
  description = "Enables forced tunneling on the security route table."
  type        = bool
  default     = true
}

variable "security_storage_bypass_ip_cidrs" {
  description = "The IP addresses to bypass for the Security storage account."
  type        = list(string)
  default    = []  
}

variable "security_storage_account_kind" {
  description = "The kind of the security storage account."
  type        = string
  default     = "StorageV2"
}

variable "security_storage_account_tier" {
  description = "The tier of the security storage account."
  type        = string
  default     = "Standard"
}

variable "security_storage_account_replication_type" {
  description = "The replication type of the security storage account."
  type        = string
  default     = "ZRS"
}