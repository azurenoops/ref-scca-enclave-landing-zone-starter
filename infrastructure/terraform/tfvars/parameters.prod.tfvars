# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

###########################
## Global Configuration  ##
###########################

# The prefixes to use for all resources in this deployment
org_name           = "anoa"    # This Prefix will be used on most deployed resources.  10 Characters max.
deploy_environment = "prod"    # dev | test | prod
environment        = "public" # public | usgovernment

# The default region to deploy to
default_location = "eastus"

# Enable locks on resources
enable_resource_locks = false # true | false

########################################
# 01 Management Groups Configuration  ##
########################################

enable_management_groups           = false   # enable management groups for this subscription
root_management_group_id           = "anoa" # the root management group id for this subscription
root_management_group_display_name = "anoa" # the root management group display name for this subscription

# Management groups to create
# The management group structure is created in the locals.tf file

################################################
# 02 Management Groups Roles Configuration  ##
################################################

deploy_custom_roles = false # true | false

# Management Groups Roles to create
# The management group roles structure is created in the locals.tf file

################################
# Landing Zone Configuration  ##
################################

###########################
# Customer Managed Keys  ##
###########################

# Use Customer Managed Keys when landing Zone is on a IL4 or IL5 environments
enable_customer_managed_keys = false

#######################################
# 03 Management Hub Virtual Network  ##
#######################################

# (Required)  Hub Virtual Network Parameters   
# Provide valid VNet Address space and specify valid domain name for Private DNS Zone.  
hub_vnet_address_space              = ["10.0.128.0/23"]  # (Required)  Hub Virtual Network Parameters  
fw_client_snet_address_prefixes     = ["10.0.128.0/26"]  # (Required)  Hub Firewall Subnet Parameters  
fw_management_snet_address_prefixes = ["10.0.128.64/26"] # (Optional)  Hub Firewall Management Subnet Parameters. If not provided, force_tunneling is not needed. 

# (Required) DDOS Protection Plan
# By default, Azure NoOps will create DDOS Protection Plan in Hub VNet.
# If you do not want to create DDOS Protection Plan,
# set create_ddos_plan to false.
create_ddos_plan = true

# Enable NSG Flow Logs
# By default, this will enable flow logs traffic analytics for all subnets.
enable_traffic_analytics = true

# (Required) Hub Subnets 
# Default Subnets, Service Endpoints
# This is the default subnet with required configuration, check README.md for more details
# First address ranges from VNet Address space reserved for Firewall Subnets. 
# First three address ranges from VNet Address space reserved for Gateway, AMPLS And Firewall Subnets. 
# ex.: For 10.8.4.0/23 address space, usable address range start from "10.8.4.224/27" for all subnets.
# default subnet name will be set as per Azure NoOps naming convention by default.
# Multiple Subnets, Service delegation, Service Endpoints, Network security groups
# These are default subnets with required configuration, check README.md for more details
# NSG association to be added automatically for all subnets listed here.
# subnet name will be set as per Azure naming convention by default. expected value here is: <App or project name>
hub_subnets = {
  default = {
    name                                       = "hub"
    address_prefixes                           = ["10.0.128.128/26"]
    service_endpoints                          = ["Microsoft.Storage"]
    private_endpoint_network_policies_enabled  = "Disabled"
    private_endpoint_service_endpoints_enabled = true
  },
}

################################################
# 03a Management Operations/Security Logging ###
################################################

########################################
## Automation Account Configuration  ###
########################################

# Enable Automation Account Linking to Log Analytics Workspace
enable_linked_automation_account_creation = true
automation_account_sku_name               = "Basic"

#############################
## Logging Configuration  ###
#############################

# Log Analytics Workspace Configuration
log_analytics_workspace_allow_resource_only_permissions    = true
log_analytics_workspace_cmk_for_query_forced               = true
log_analytics_workspace_daily_quota_gb                     = 1
log_analytics_workspace_internet_ingestion_enabled         = true
log_analytics_workspace_internet_query_enabled             = true
log_analytics_workspace_reservation_capacity_in_gb_per_day = 0 # CapacityReservation is not supported in this configuration
log_analytics_logs_retention_in_days                       = 50
log_analytics_workspace_sku                                = "PerGB2018"

################################################
# 03a Management Operations Logging Settings ###
################################################

# Azure Monitor Settings
# All solutions are enabled (false) by default
# These soluions will be enabled on both logging and security logging modules
# Sentinel is already enabled by default on the security logging module
enable_azure_activity_log    = true
enable_vm_insights           = true
enable_azure_security_center = true
enable_container_insights    = true
enable_key_vault_analytics   = true
enable_service_map           = true

##################################
## Misc Logging Configuration  ###
##################################

# (Optional) To enable Azure Monitoring Private Link Scope
# Enable Azure Monitor Private Link Scope
enable_ampls                  = true
ampls_subnet_address_prefixes = ["10.0.134.0/27"] # (Required) AMPLS Subnet Parameter

#################################
# 03b Management Hub Firewall ###
#################################

# Firewall Settings
# By default, Azure NoOps will create Azure Firewall in Hub VNet. 
# If you do not want to create Azure Firewall, 
# set enable_firewall to false. This will allow different firewall products to be used (Example: F5).  
enable_firewall = true

# By default, forced tunneling is enabled for Azure Firewall.
# If you do not want to enable forced tunneling, 
# set enable_forced_tunneling to false.
enable_forced_tunneling = true

# (Optional) To enable the availability zones for firewall. 
# Availability Zones can only be configured during deployment 
# You can't modify an existing firewall to include Availability Zones
firewall_zones = []

# DNS Servers for Firewall
# By default, Azure NoOps will use Azure DNS for Azure Firewall DNS settings.
# The Azure Firewall DNS Proxy will forward all DNS traffic.
# To override the default DNS settings, set the argument to `dns_servers`.
enable_dns_proxy = true

# The Azure Firewall DNS Proxy will forward all DNS traffic. This should be a comma separated list of IP addresses to forward DNS traffic.
dns_servers = ["168.63.129.16"]

# CIDRs for Hub Azure Storage Account to bypass Azure Firewall
hub_storage_bypass_ip_cidrs =[]

# # (Optional) specify the Network rules for Azure Firewall l
# This is default values, do not need this if keeping default values
firewall_network_rules = [
  {
    name     = "AllowAzureCloud"
    priority = "100"
    action   = "Allow"
    rule = [
      {
        name                  = "AzureCloud"
        protocols             = ["Any"]
        source_addresses      = ["*"]
        destination_addresses = ["AzureCloud"]
        destination_ports     = ["*"]
      }
    ]
  },
  {
    name     = "AllowTrafficBetweenSpokes"
    priority = "200"
    action   = "Allow"
    rule = [
      {
        name                  = "AllSpokeTraffic"
        protocols             = ["Any"]
        source_addresses      = ["10.0.128.0/18"]
        destination_addresses = ["*"]
        destination_ports     = ["*"]
      }
    ]
  }
]

# (Optional) specify the application rules for Azure Firewall
# This is default values, do not need this if keeping default values
firewall_application_rules = [
  {
    name     = "AzureAuth"
    priority = "110"
    action   = "Allow"
    rule = [
      {
        name              = "msftauth"
        source_addresses  = ["*"]
        destination_fqdns = ["aadcdn.msftauth.net", "aadcdn.msauth.net"]
      }
    ]
    protocols = [
      {
        type = "Https"
        port = 443
      }
    ]
  }
]

#######################################
# 03b Bastion/Hub Private DNS Zones ###
#######################################

# Private DNS Zone Settings
# By default, Azure NoOps will create Private DNS Zones for Logging in Hub VNet.
# If you do want to create additional Private DNS Zones, 
# add in the list of private_dns_zones to be created.
# else, remove the private_dns_zones argument.
hub_private_dns_zones = []

# By default, this module will create a bastion host, 
# and set the argument to `enable_bastion_host = false`, to disable the bastion host.
enable_bastion_host                 = true
azure_bastion_host_sku              = "Standard"
azure_bastion_subnet_address_prefix = ["10.0.128.192/26"]
enable_hybrid_use_benefit           = false # This is only used for windows machines

####################################################
# 03c Identity Management Spoke Virtual Network   ###
####################################################

# Enable Identity Management Spoke Virtual Network
# If you do not want to create Identity Management Spoke Virtual Network,
# remove this section from the configuration file.

# Identity Virtual Network Parameters
id_vnet_address_space = ["10.0.130.0/24"]
id_subnets = {
  default = {
    name                                       = "id"
    address_prefixes                           = ["10.0.130.0/24"]
    service_endpoints                          = ["Microsoft.Storage"]
    private_endpoint_network_policies_enabled  = "Disabled"
    private_endpoint_service_endpoints_enabled = true
    nsg_subnet_rules = [
      {
        name                       = "Allow-Traffic-From-Spokes",
        description                = "Allow traffic from spokes",
        priority                   = 200,
        direction                  = "Inbound",
        access                     = "Allow",
        protocol                   = "*",
        source_port_range          = "*",
        destination_port_ranges    = ["22", "80", "443", "3389"],
        source_address_prefixes    = ["10.0.131.0/24", "10.0.132.0/24", "10.0.133.0/24"]
        destination_address_prefix = "10.0.130.0/24"
      }
    ]
  }
}

# Enable forced tunneling on the route table
enable_forced_tunneling_on_id_route_table = true

# CIDRs for Identity Spkoke Azure Storage Account to bypass Azure Firewall
id_storage_bypass_ip_cidrs = []

####################################################
# 03d Operations Management Spoke Virtual Network ###
####################################################

# Operations Virtual Network Parameters
ops_vnet_address_space = ["10.0.131.0/24"]
ops_subnets = {
  default = {
    name                                       = "ops"
    address_prefixes                           = ["10.0.131.0/24"]
    service_endpoints                          = ["Microsoft.Storage"]
    private_endpoint_network_policies_enabled  = "Disabled"
    private_endpoint_service_endpoints_enabled = true
    nsg_subnet_rules = [
      {
        name                       = "Allow-Traffic-From-Spokes",
        description                = "Allow traffic from spokes",
        priority                   = 200,
        direction                  = "Inbound",
        access                     = "Allow",
        protocol                   = "*",
        source_port_range          = "*",
        destination_port_ranges    = ["22", "80", "443", "3389"],
        source_address_prefixes    = ["10.0.130.0/24", "10.0.132.0/24", "10.0.133.0/24"]
        destination_address_prefix = "10.0.131.0/24"
      }
    ]
  },
  ampls = {
    name                                       = "ampls"
    address_prefixes                           = ["10.0.131.64/27"]
    service_endpoints                          = []
    private_endpoint_network_policies_enabled  = "Disabled"
    private_endpoint_service_endpoints_enabled = true
    nsg_subnet_rules                           = []
  }
}

# Enable forced tunneling on the route table
enable_forced_tunneling_on_ops_route_table = true

# CIDRs for Operations Spkoke Azure Storage Account to bypass Azure Firewall
ops_storage_bypass_ip_cidrs = []

##########################################################
# 03e DevSecOps Management Spoke Virtual Network       ###
##########################################################

# DevSecOps Virtual Network Parameters
devsecops_vnet_address_space = ["10.0.132.0/24"]
devsecops_subnets = {
  default = {
    name                                       = "devsecops"
    address_prefixes                           = ["10.0.132.0/24"]
    service_endpoints                          = ["Microsoft.Storage", "Microsoft.KeyVault"]
    private_endpoint_network_policies_enabled  = "Disabled"
    private_endpoint_service_endpoints_enabled = true
    nsg_subnet_rules = [
      {
        name                       = "Allow-Traffic-From-Spokes",
        description                = "Allow traffic from spokes",
        priority                   = 200,
        direction                  = "Inbound",
        access                     = "Allow",
        protocol                   = "*",
        source_port_range          = "*",
        destination_port_ranges    = ["22", "80", "443", "3389"],
        source_address_prefixes    = ["10.0.131.0/24", "10.0.133.0/24", "10.0.130.0/24"]
        destination_address_prefix = "10.0.132.0/24"
      }
    ]
  }
}

# Enable forced tunneling on the route table
enable_forced_tunneling_on_devsecops_route_table = true

# CIDRs for DevSecOps Spkoke Azure Storage Account to bypass Azure Firewall
devsecops_storage_bypass_ip_cidrs = []

####################################################
# 03e Security Management Spoke Virtual Network  ###
####################################################

# Security Virtual Network Parameters
security_name               = "security"
security_vnet_address_space = ["10.0.133.0/24"]
security_subnets = {
  default = {
    name                                       = "security"
    address_prefixes                           = ["10.0.133.0/24"]
    service_endpoints                          = ["Microsoft.Storage", "Microsoft.KeyVault"]
    private_endpoint_network_policies_enabled  = "Disabled"
    private_endpoint_service_endpoints_enabled = true
    nsg_subnet_rules = [
      {
        name                       = "Allow-Traffic-From-Spokes",
        description                = "Allow traffic from spokes",
        priority                   = 200,
        direction                  = "Inbound",
        access                     = "Allow",
        protocol                   = "*",
        source_port_range          = "*",
        destination_port_ranges    = ["22", "80", "443", "3389"],
        source_address_prefixes    = ["10.0.131.0/24", "10.0.132.0/24", "10.0.130.0/24"]
        destination_address_prefix = "10.0.133.0/24"
      }
    ]
  },
}

# Enable forced tunneling on the route table
enable_forced_tunneling_on_security_route_table = true

# CIDRs for Security Spkoke Azure Storage Account to bypass Azure Firewall
security_storage_bypass_ip_cidrs = []

#############################
## Peering Configuration  ###
#############################

# Peering Configuration
# By default, Azure NoOps will create peering between hub and spoke vnets.
use_remote_spoke_gateway = false

###############################################
# 03g DevecOps Management Spoke Components  ###
###############################################

# Azure Key Vault
keyvault_name                            = "sh-keys"
keyvault_sku                             = "standard" # The SKU of the keyvault.
keyvault_public_network_access_enabled   = false      # Enable public network access for the keyvault.
keyvault_soft_delete_retention_days      = 7          # The soft delete retention days for the keyvault.
keyvault_enabled_for_purge_protection    = true       # Enable purge protection for the keyvault.
keyvault_enabled_for_deployment          = true       # Enable deployment for the keyvault.
keyvault_enabled_for_disk_encryption     = true       # Enable disk encryption for the keyvault.
keyvault_enabled_for_template_deployment = true       # Enable template deployment for the keyvault.

# Bypass IP CIDRs for KeyVault
keyvault_bypass_ip_cidrs = []

# Bastion Windows VM Configuration
win_source_image_reference = {
  publisher = "MicrosoftWindowsServer"
  offer     = "WindowsServer"
  sku       = "2019-Datacenter"
  version   = "latest"
}

# Bastion Linux VM Configuration
linux_source_image_reference = {
  publisher = "Canonical"
  offer     = "UbuntuServe"
  sku       = "18.04-LTS"
  version   = "latest"
}

# Check the README.md file for more pre-defined images for Windows, Ubuntu, Centos, RedHat.
# Please make sure to use gen2 images supported VM sizes if you use gen2 distributions
# Specify a valid password with `admin_password` argument to use your own password .  
vm_admin_username = "azureuser"

# Attach a managed data disk to a Windows/windows virtual machine. 
# Storage account types include: #'Standard_LRS', #'StandardSSD_ZRS', #'Premium_LRS', #'Premium_ZRS', #'StandardSSD_LRS', #'UltraSSD_LRS' (UltraSSD_LRS is only accessible in regions that support availability zones).
# Create a new data drive - connect to the VM and execute diskmanagement or fdisk.
data_disks = {
  disk1 = {
    name                 = "vm-dsk-lun0"
    storage_account_type = "StandardSSD_LRS"
    lun                  = 0
    caching              = "ReadWrite"
    disk_size_gb         = 32
  }
}

########################################### 
# 04 Azure Service Health Configuration  ##
###########################################

# Azure Service Health Configuration
enable_service_health_monitoring = true
action_group_short_name          = "anoaalerting"

##########################################
# 05  Defender for Cloud Configuration  ##
##########################################

enable_defender_for_cloud           = false # Enable Defender for Cloud
security_center_contact_email       = "admin@contoso.com"
security_center_contact_phone       = "xxx-xxx-xxxx"
security_center_alert_notifications = true
security_center_alerts_to_admins    = true

# Defender Configuration
security_center_pricing_tier           = "Standard" # Free | Standard
security_center_pricing_resource_types = ["KeyVaults", "StorageAccounts", "VirtualMachines"]
