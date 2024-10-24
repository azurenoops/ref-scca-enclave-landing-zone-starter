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

variable "devsecops_vnet_address_space" {
  description = "The address space of the devsecops virtual network."
  type        = list(string)
  default     = ["10.8.6.0/26"]
}

variable "devsecops_subnets" {
  description = "The subnets of the devsecops virtual network."
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

variable "enable_forced_tunneling_on_devsecops_route_table" {
  description = "Enables forced tunneling on the devsecops route table."
  type        = bool
  default     = true
}

variable "devsecops_storage_bypass_ip_cidrs" {
  description = "The IP addresses to bypass for the devsecops storage account."
  type        = list(string)
  default     = []
}

variable "devsecops_storage_account_kind" {
  description = "The kind of the devsecops storage account."
  type        = string
  default     = "StorageV2"
}

variable "devsecops_storage_account_tier" {
  description = "The tier of the devsecops storage account."
  type        = string
  default     = "Standard"
}

variable "devsecops_storage_account_replication_type" {
  description = "The replication type of the devsecops storage account."
  type        = string
  default     = "ZRS"
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

variable "keyvault_admins_group_object_id" {
  description = "The object ID of the admins group that will be given access to the keyvault."
  type        = string
  sensitive   = true
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

variable "vm_sku_size" {
  description = "The size of the Bastion VM. Commerical SKUs are looked up based on the region."
  type        = string
  default     = "Standard_D2s_v3"
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

variable "enable_encryption_at_host" {
  description = "Enables encryption at host for the Bastion VM."
  type        = bool
  default     = false  
}

