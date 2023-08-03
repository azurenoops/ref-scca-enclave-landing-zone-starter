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

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the resources will be deployed."
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the virtual network in which the resources will be deployed."
}

variable "subnet_name" {
  type        = string
  description = "The name of the subnet in which the resources will be deployed."
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

variable "rbac_authorization_enabled" {
  description = "If set to true, will enable RBAC authorization for the Key Vault. Default is false."
  type        = bool
  default     = false
}

variable "enable_key_vault_private_endpoint" {
  description = "If set to true, will deploy a private endpoint for the Key Vault."
  type        = bool
  default     = false
} 

###############################
# Bastion VM Configuration   ##
###############################

variable "windows_distribution_name" {
  description = "The name of the Windows distribution to use for the Bastion VM."
  type        = string
  default     = "windows2019dc"
}

variable "virtual_machine_size" {
  description = "The size of the Bastion VM."
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "The name of the administrator account for the Bastion VM."
  type        = string
  default     = "azureadmin"
}

variable "admin_password" {
  description = "The password for the administrator account for the Bastion VM."
  type        = string
}

variable "instances_count" {
  description = "The number of Bastion VM instances to deploy."
  type        = number
  default     = 1
}

variable "enable_proximity_placement_group" {
  description = "If set to true, will deploy a proximity placement group for the Bastion VM. Default is false."
  type        = bool
  default     = false
}

variable "enable_vm_availability_set" {
  description = "If set to true, will deploy an availability set for the Bastion VM. Default is false."
  type        = bool
  default     = false
}

variable "enable_public_ip_address" {
  description = "If set to true, will deploy a public IP address for the Bastion VM. Default is false."
  type        = bool
  default     = false
}

variable "existing_network_security_group_name" {
  description = "The name of an existing network security group to associate with the Bastion VM."
  type        = string
  default     = null
}
  
variable "nsg_inbound_rules" {
  description = "A list of inbound rules to associate with the network security group."  
  default = []
}

variable "enable_boot_diagnostics" {
  description = "If set to true, will enable boot diagnostics for the Bastion VM. Default is false."
  type        = bool
  default     = false
}

variable "data_disks" {
  description = "A list of data disks to attach to the Bastion VM."
  default = []
}

variable "deploy_log_analytics_agent" {
  description = "If set to true, will deploy the Log Analytics agent to the Bastion VM. Default is false."
  type        = bool
  default     = false
}

variable "log_analytics_resource_id" {
  description = "The resource ID of the Log Analytics workspace to which the Bastion VM should be connected."
  type        = string
  default     = null
}

variable "log_analytics_workspace_id" {
  description = "The workspace ID of the Log Analytics workspace to which the Bastion VM should be connected."
  type        = string
  default     = null
}

variable "log_analytics_primary_shared_key" {
  description = "The primary shared key of the Log Analytics workspace to which the Bastion VM should be connected."
  type        = string
  default     = null
}

