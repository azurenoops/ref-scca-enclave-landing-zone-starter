# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
  PARAMETERS
  Here are all the variables a user can override.
*/

################################
# Landing Zone Configuration  ##
################################

##########
# Hub  ###
##########

variable "hub_name" {
  description = "A name for the hub. It defaults to hub-core."
  type        = string
  default     = "hub"
}

variable "hub_vnet_address_space" {
  description = "The address space of the hub virtual network."
  type        = list(string)
  default     = ["10.0.128.0/23"]
}

variable "ampls_subnet_address_prefixes" {
  description = "The address prefix of the ampls subnet."
  type        = list(string)
  default     = ["10.0.134.0/27"]
}

variable "hub_subnets" {
  description = "The subnets of the hub virtual network."
  default     = {}
}

variable "enable_traffic_analytics" {
  description = "Enable Traffic Analytics for NSG Flow Logs"
  type        = bool
  default     = false
}

variable "hub_private_dns_zones" {
  description = "The private DNS zones of the hub virtual network."
  type        = list(string)
  default     = []
}

variable "create_ddos_plan" {
  description = "Create a DDoS protection plan for the hub virtual network."
  type        = bool
  default     = true
}

variable "firewall_supernet_IP_address" {
  description = "The IP address of the firewall supernet."
  type        = string
  default     = "10.0.128.0/18"
}

variable "fw_client_snet_address_prefixes" {
  description = "The address prefix of the firewall subnet."
  type        = list(string)
  default     = ["10.0.128.0/26"]
}

variable "fw_management_snet_address_prefixes" {
  description = "The address prefix of the firewall subnet."
  type        = list(string)
  default     = ["10.0.128.64/26"]
}

variable "firewall_zones" {
  description = "The zones of the firewall. Valid values are 1, 2, and 3."
  default     = []
}

variable "enable_dns_proxy" {
  description = "Enable [true/false] The Azure Firewall DNS Proxy will forward all DNS traffic. When this value is set to true, you must provide a value for 'dns_servers'."
  type        = bool
  default     = true
}

variable "dns_servers" {
  description = "['168.63.129.16'] The Azure Firewall DNS Proxy will forward all DNS traffic. When this value is set to true, you must provide a value for 'dns_servers'. This should be a comma separated list of IP addresses to forward DNS traffic."
  type        = list(string)
  default     = ["168.63.129.16"]
}

variable "hub_storage_bypass_ip_cidr" {
  description = "The CIDRs for Azure Storage Account. This will allow the specified CIDRs to bypass the Azure Firewall for Azure Storage Account."
  type        = list(string)
  default     = []
}

variable "enable_firewall" {
  description = "Enables an Azure Firewall"
  type        = bool
  default     = true
}

variable "firewall_application_rules" {
  description = "List of application rules to apply to firewall."
  type        = any
  default     = []
}

variable "firewall_network_rules" {
  description = "List of network rules to apply to firewall."
  type        = any
  default     = []
}

variable "firewall_nat_rules" {
  description = "List of nat rules to apply to firewall."
  type        = any
  default     = []
}

variable "enable_forced_tunneling" {
  description = "Enables Force Tunneling for Azure Firewall"
  type        = bool
  default     = true
}

variable "enable_bastion_host" {
  description = "Enables an Azure Bastion Host"
  type        = bool
  default     = true
}

variable "azure_bastion_host_sku" {
  description = "The SKU of the Azure Bastion Host. Possible values are Standard and Basic. Default is Standard."
  type        = string
  default     = "Standard"
}

variable "azure_bastion_subnet_address_prefix" {
  description = "The address prefix of the Azure Bastion Host subnet."
  type        = list(string)
  default     = null
}

variable "gateway_vnet_address_space" {
  description = "The address space of the gateway virtual network."
  type        = list(string)
  default     = ["10.8.4.0/27"]
}

#############################
## Peering Configuration  ###
#############################

variable "use_remote_spoke_gateway" {
  description = "Option use_remote_gateway for the spoke vnet to peer. Controls if remote gateways can be used on the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#use_remote_gateways"
  type        = bool
  default     = null
}
