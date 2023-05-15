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
# Management Logging  ###
#########################

variable "enable_management_logging" {
  description = "Enable Management Logging. It defaults to true."
  type        = bool
  default     = true
}

variable "ampls_subnet_address_prefixes" {
  description = "A name for the ops logging. It defaults to ops-logging-core."
  type        = list(string)
  default     = ["10.8.5.160/27"]
}

variable "log_analytics_workspace_sku" {
  description = "The SKU of the Log Analytics Workspace. Possible values are PerGB2018 and Free. Default is PerGB2018."
  type        = string
  default     = null
}

variable "log_analytics_logs_retention_in_days" {
  description = "The number of days to retain logs for. Possible values are between 30 and 730. Default is 30."
  type        = number
  default     = null
}

##########
# Hub  ###
##########

variable "hub_name" {
  description = "A name for the hub. It defaults to hub-core."
  type        = string
  default     = "hub-core"
}

variable "hub_vnet_address_space" {
  description = "The address space of the hub virtual network."
  type        = list(string)
  default     = ["10.8.4.0/23"]
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

variable "firewall_supernet_IP_address" {
  description = "The IP address of the firewall supernet."
  type        = string
  default     = "10.0.96.0/19"
}

variable "fw_client_snet_address_prefixes" {
  description = "The address prefix of the firewall subnet."
  type        = list(string)
  default     = ["10.8.4.64/26"]
}

variable "fw_management_snet_address_prefixes" {
  description = "The address prefix of the firewall subnet."
  type        = list(string)
  default     = ["10.8.4.128/26"]
}

variable "firewall_zones" {
  description = "The zones of the firewall. Valid values are 1, 2, and 3."
  default     = [1, 2, 3]
}

variable "enable_firewall" {
  description = "Enables an Azure Firewall"
  type        = bool
  default     = true
}

variable "firewall_application_rules" {
  description = "List of application rules to apply to firewall."
  default     = {}  
}

variable "firewall_network_rules" {
  description = "List of network rules to apply to firewall."
  default     = {}
}

variable "firewall_nat_rules" {
  description = "List of nat rules to apply to firewall."
  default     = {}
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

#################
# Operations  ###
#################

variable "ops_name" {
  description = "A name for the ops. It defaults to ops-core."
  type        = string
  default     = "ops-core"
}

variable "ops_vnet_address_space" {
  description = "The address space of the operations virtual network."
  type        = list(string)
  default     = ["10.8.6.0/26"]
}

variable "ops_subnets" {
  description = "The subnets of the operations virtual network."
  default     = {}
}

variable "is_ops_spoke_deployed_to_same_hub_subscription" {
  description = "Indicates whether the operations spoke is deployed to the same hub subscription."
  type        = bool
  default     = true
}

variable "enable_forced_tunneling_on_ops_route_table" {
  description = "Enables forced tunneling on the operations route table."
  type        = bool
  default     = true
}

variable "ops_private_dns_zones" {
  description = "The private DNS zones of the operations virtual network."
  type        = list(string)
  default     = []
}

######################
# Shared Services  ###
######################

variable "svcs_name" {
  description = "A name for the svcs. It defaults to svcs-core."
  type        = string
  default     = "svcs-core"
}

variable "svcs_vnet_address_space" {
  description = "The address space of the svcs virtual network."
  type        = list(string)
  default     = ["10.8.7.0/26"]
}

variable "svcs_subnets" {
  description = "The subnets of the svcs virtual network."
  default     = {}
}

variable "is_svcs_spoke_deployed_to_same_hub_subscription" {
  description = "Indicates whether the shared services spoke is deployed to the same hub subscription."
  type        = bool
  default     = true
}

variable "enable_forced_tunneling_on_svcs_route_table" {
  description = "Enables forced tunneling on the shared services spoke route table."
  type        = bool
  default     = true
}

variable "svcs_private_dns_zones" {
  description = "The private DNS zones of the shared services spoke virtual network."
  type        = list(string)
  default     = []
}

#############################
## Peering Configuration  ###
#############################

variable "use_remote_spoke_gateway" {
  description = "Option use_remote_gateway for the spoke vnet to peer. Controls if remote gateways can be used on the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#use_remote_gateways"
  type        = bool
  default     = null
}
