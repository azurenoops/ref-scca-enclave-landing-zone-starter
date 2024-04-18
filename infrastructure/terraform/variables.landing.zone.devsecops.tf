# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
  PARAMETERS
  Here are all the variables a user can overrdevsecopse.
*/

################################
# Landing Zone Configuration  ##
################################

#################
# DevSecOps   ###
#################

variable "devsecops_name" {
  description = "A name for the devsecops. It defaults to devsecops."
  type        = string
  default     = "devsecops"
}

variable "devsecops_vnet_address_space" {
  description = "The address space of the devsecops virtual network."
  type        = list(string)
  default     = ["10.8.6.0/26"]
}

variable "devsecops_subnets" {
  description = "The subnets of the devsecops virtual network."
  default     = {}
}

variable "enable_forced_tunneling_on_devsecops_route_table" {
  description = "Enables forced tunneling on the devsecops route table."
  type        = bool
  default     = true
}

##########################
# DevSecOps KeyVault   ###
##########################

variable "keyvault_name" {
  description = "A name for the keyvault. It defaults to shared-keys."
  type        = string
  default     = "shared-keys"
}

variable "keyvault_sku" {
  description = "The SKU of the keyvault."
  type        = string
  default     = "standard"
}

variable "keyvault_contact_name" {
  description = "The contact name for the keyvault."
  type        = string
  default     = "Azure Security"  
}

variable "keyvault_contact_email" {
  description = "The contact email for the keyvault."
  type        = string
  default     = "anoa@contoso.com"
}

variable "keyvault_contact_phone" {
  description = "The contact phone for the keyvault."
  type        = string
  default     = "123-456-7890"  
}

variable "keyvault_bypass_ip_cidrs" {
  description = "The IP addresses to bypass for the keyvault."
  type        = list(string)
  default    = []  
}

variable "keyvault_public_network_access_enabled" {
  description = "Enable public network access for the keyvault."
  type        = bool
  default     = true
}

variable "keyvault_soft_delete_retention_days" {
  description = "The soft delete retention days for the keyvault."
  type        = number
  default     = 90
}

variable "keyvault_enabled_for_deployment" {
  description = "Enable deployment for the keyvault."
  type        = bool
  default     = false
}

variable "keyvault_enabled_for_disk_encryption" {
  description = "Enable disk encryption for the keyvault."
  type        = bool
  default     = true
}

variable "keyvault_enabled_for_template_deployment" {
  description = "Enable template deployment for the keyvault."
  type        = bool
  default     = false
}

variable "keyvault_enabled_for_purge_protection" {
  description = "Enable purge protection for the keyvault."
  type        = bool
  default     = true
}

###############################
# Bastion VM Configuration   ##
###############################

variable "win_source_image_reference" {
  description = "The name of the Windows distribution to use for the Bastion VM."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = null
}

variable "linux_source_image_reference" {
  description = "The name of the Windows distribution to use for the Bastion VM."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = null
}

variable "vm_admin_username" {
  description = "The name of the administrator account for the Bastion VM."
  type        = string
  default     = "azureadmin"
}

variable "vm_admin_password" {
  description = "The password for the administrator account for the Bastion VM."
  type        = string
  sensitive   = true
}

variable "enable_boot_diagnostics" {
  description = "If set to true, will enable boot diagnostics for the Bastion VM. Default is false."
  type        = bool
  default     = false
}

variable "data_disks" {
  description = "A list of data disks to attach to the Bastion VM."
  type        = any
  default     = {}
}

variable "enable_hybrid_use_benefit" {
  description = "Enables the hybrid use benefit provides a discount on virtual machines when a customer has an on-premises Windows Server license with Software Assurance."
  type        = bool
  default     = false
}

