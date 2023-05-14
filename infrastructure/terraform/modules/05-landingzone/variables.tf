# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
  PARAMETERS
  Here are all the variables a user can override.
*/

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

variable "subscription_id_hub" {
  type        = string
  description = "If specified, identifies the Platform subscription for \"Hub\" for resource deployment and correct placement in the Management Group hierarchy."

  validation {
    condition     = can(regex("^[a-z0-9-]{36}$", var.subscription_id_hub)) || var.subscription_id_hub == ""
    error_message = "Value must be a valid Subscription ID (GUID)."
  }
}

variable "subscription_id_identity" {
  type        = string
  description = "If specified, identifies the Platform subscription for \"Identity\" for resource deployment and correct placement in the Management Group hierarchy."
}

variable "subscription_id_operations" {
  type        = string
  description = "If specified, identifies the Platform subscription for \"Operations\" for resource deployment and correct placement in the Management Group hierarchy."
}

variable "subscription_id_sharedservices" {
  type        = string
  description = "If specified, identifies the Platform subscription for \"Shared Services\" for resource deployment and correct placement in the Management Group hierarchy."
}

#################################
# Remote State Configuration
#################################

## This is required for retrieving state
variable "state_sa_name" {
  type        = string
  description = "The name of the storage account to use for storing the Terraform state."
}

variable "state_sa_container_name" {
  type        = string
  description = "The name of the container to use for storing the Terraform state."
}

# Storage Account Resource Group
variable "state_sa_rg" {
  type        = string
  description = "The name of the resource group in which the storage account is located."
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

################################
# Landing Zone Configuration  ##
################################

#########################
# Management Logging  ###
#########################

variable "ampls_subnet_address_prefix" {
  description = "A name for the ops logging. It defaults to ops-logging-core."
  type        = string
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
  description = "Name of the hub network name. This will be used to name the resources deployed by this module. default is 'hub-core'"
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
  type = list(object({
    name             = string
    description      = optional(string)
    action           = string
    source_addresses = optional(list(string))
    source_ip_groups = optional(list(string))
    fqdn_tags        = optional(list(string))
    target_fqdns     = optional(list(string))
    protocol = optional(object({
      type = string
      port = string
    }))
  }))
  default = []
}

variable "firewall_network_rules" {
  description = "List of network rules to apply to firewall."
  type = list(object({
    name                  = string
    description           = optional(string)
    action                = string
    source_addresses      = optional(list(string))
    destination_ports     = list(string)
    destination_addresses = optional(list(string))
    destination_fqdns     = optional(list(string))
    protocols             = list(string)
  }))
  default = []
}

variable "firewall_nat_rules" {
  description = "List of nat rules to apply to firewall."
  type = list(object({
    name                  = string
    description           = optional(string)
    action                = string
    source_addresses      = optional(list(string))
    destination_ports     = list(string)
    destination_addresses = list(string)
    protocols             = list(string)
    translated_address    = string
    translated_port       = string
  }))
  default = []
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
  type        = string
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

variable "use_source_remote_spoke_gateway" {
  description = "Indicates whether to use the source remote spoke gateway."
  type        = bool
  default     = false
}
 

