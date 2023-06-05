# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

###########################
## Global Configuration  ##
###########################

# The prefixes to use for all resources in this deployment
org_name           = "anoa"   # This Prefix will be used on most deployed resources.  10 Characters max.
deploy_environment = "dev"    # dev | test | prod
environment        = "public" # public | usgovernment

# The default region to deploy to
default_location = "eastus"

# Enable locks on resources
enable_resource_locks = false # true | false

# Enable NSG Flow Logs
# By default, this will enable flow logs traffic analytics for all subnets.
enable_traffic_analytics = true

########################################
# 02 Management Groups Configuration  ##
########################################

enable_management_groups           = false   # enable management groups for this subscription
root_management_group_id           = "anoa" # the root management group id for this subscription
root_management_group_display_name = "anoa" # the root management group display name for this subscription

# Management groups to create
# The management group structure is created in the locals.tf file

################################################
# 03 Management Groups Budgets Configuration  ##
################################################

# Budgets for management groups
enable_management_groups_budgets = false                  # enable budgets for management groups
budget_contact_emails            = ["anoa@microsoft.com"] # email addresses to send alerts to for this subscription

################################################
# 04 Management Groups Roles Configuration  ##
################################################

deploy_custom_roles = false # true | false

################################
# Landing Zone Configuration  ##
################################

#######################################
# 05 Management Hub Virtual Network  ##
#######################################

# (Required)  Hub Virtual Network Parameters   
# Provide valid VNet Address space and specify valid domain name for Private DNS Zone.  
hub_vnet_address_space              = ["10.8.4.0/23"]   # (Required)  Hub Virtual Network Parameters  
fw_client_snet_address_prefixes     = ["10.8.4.64/26"]  # (Required)  Hub Firewall Subnet Parameters  
ampls_subnet_address_prefixes       = ["10.8.5.160/27"] # (Required)  AMPLS Subnet Parameter
fw_management_snet_address_prefixes = ["10.8.4.128/26"] # (Optional)  Hub Firewall Management Subnet Parameters. If not provided, force_tunneling is not needed.
gateway_vnet_address_space          = ["10.8.4.0/27"]   # (Optional)  Hub Gateway Subnet Parameters

# (Required) Hub Subnets 
# Default Subnets, Service Endpoints
# This is the default subnet with required configuration, check README.md for more details
# First address ranges from VNet Address space reserved for Firewall Subnets. 
# First three address ranges from VNet Address space reserved for Gateway, AMPLS And Firewall Subnets. 
# ex.: For 10.8.4.0/23 address space, usable address range start from "10.8.4.224/27" for all subnets.
# default subnet name will be set as per Azure NoOps naming convention by defaut.
# Multiple Subnets, Service delegation, Service Endpoints, Network security groups
# These are default subnets with required configuration, check README.md for more details
# NSG association to be added automatically for all subnets listed here.
# subnet name will be set as per Azure naming convention by defaut. expected value here is: <App or project name>
hub_subnets = {
  default = {
    name                                       = "hub-core"
    address_prefixes                           = ["10.8.4.224/27"]
    service_endpoints                          = ["Microsoft.Storage"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true
  }

  dmz = {
    name                                       = "app-gateway"
    address_prefixes                           = ["10.8.5.64/27"]
    service_endpoints                          = ["Microsoft.Storage"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true
    nsg_subnet_inbound_rules = [
      # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
      # To use defaults, use "" without adding any value and to use this subnet as a source or destination prefix.
      # 65200-65335 port to be opened if you planning to create application gateway
      ["http", "100", "Inbound", "Allow", "Tcp", "80", "*", ["0.0.0.0/0"]],
      ["https", "200", "Inbound", "Allow", "Tcp", "443", "*", [""]],
      ["appgwports", "300", "Inbound", "Allow", "Tcp", "65200-65335", "*", [""]],

    ]
    nsg_subnet_outbound_rules = [
      # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
      # To use defaults, use "" without adding any value and to use this subnet as a source or destination prefix.
      ["ntp_out", "400", "Outbound", "Allow", "Udp", "123", "", ["0.0.0.0/0"]],
    ]
  }
}

########################################
# 05a Management OperationL Logging  ###
########################################

# All Log solutions are enabled (true) by default.
log_analytics_workspace_sku          = "PerGB2018"
log_analytics_logs_retention_in_days = 30

#################################
# 05b Management Hub Firewall ###
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

# # (Optional) specify the Network rules for Azure Firewall l
# This is default values, do not need this if keeping default values
firewall_network_rules = [
  {
    name     = "AllowAzureCloud"
    priority = "100"
    action   = "Allow"
    rules = [
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
    rules = [
      {
        name                  = "AllSpokeTraffic"
        protocols             = ["Any"]
        source_addresses      = ["10.96.0.0/19"]
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
    rules = [
      {
        name              = "msftauth"
        source_addresses  = ["*"]
        destination_fqdns = ["aadcdn.msftauth.net", "aadcdn.msauth.net"]
        protocols = {
          type = "Https"
          port = 443
        }
      }
    ]
  }
]

###################################
# 05c Bastion/Private DNS Zones ###
###################################

# Private DNS Zone Settings
# By default, Azure NoOps will create Private DNS Zones for Logging in Hub VNet.
# If you do want to create addtional Private DNS Zones, 
# add in the list of private_dns_zones to be created.
# else, remove the private_dns_zones argument.
hub_private_dns_zones = []

# By default, this module will create a bastion host, 
# and set the argument to `enable_bastion_host = false`, to disable the bastion host.
enable_bastion_host                 = true
azure_bastion_host_sku              = "Standard"
azure_bastion_subnet_address_prefix = ["10.8.4.192/27"]


####################################################
# 5d Operations Management Spoke Virtual Network ###
####################################################

ops_name               = "ops-core"
ops_vnet_address_space = ["10.8.6.0/24"]
ops_subnets = {
  default = {
    name                                       = "ops-core"
    address_prefixes                           = ["10.8.6.224/27"]
    service_endpoints                          = ["Microsoft.Storage"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true
    nsg_subnet_inbound_rules = [
      # [name, description, priority, direction, access, protocol, destination_port_range, source_address_prefixes, destination_address_prefix]
      # Use "" for description to use default description
      # To use defaults, use [""] without adding any value and to use this subnet as a source or destination prefix.      
      ["Allow-Traffic-From-Spokes", "Allow traffic from spokes", "200", "Inbound", "Allow", "*", ["22", "80", "443", "3389"], ["10.8.7.0/24", "10.8.8.0/24"], ["10.8.6.0/24"]],
    ]
  }
}
ops_private_dns_zones                          = []
enable_forced_tunneling_on_ops_route_table     = true
is_ops_spoke_deployed_to_same_hub_subscription = true

##########################################################
# 05e Shared Services Management Spoke Virtual Network ###
##########################################################

svcs_name               = "svcs-core"
svcs_vnet_address_space = ["10.8.7.0/24"]
svcs_subnets = {
  default = {
    name                                       = "svcs-core"
    address_prefixes                           = ["10.8.7.224/27"]
    service_endpoints                          = ["Microsoft.Storage"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true
    nsg_subnet_inbound_rules = [
      # [name, description, priority, direction, access, protocol, destination_port_range, source_address_prefixes, destination_address_prefix]
      # Use "" for description to use default description
      # To use defaults, use [""] without adding any value and to use this subnet as a source or destination prefix.      
      ["Allow-Traffic-From-Spokes", "Allow traffic from spokes", "200", "Inbound", "Allow", "*", ["22", "80", "443", "3389"], ["10.8.6.0/24", "10.8.8.0/24"], ["10.8.7.0/24"]],
    ]
  },
  private-endpoints = {
    name                                       = "pe"
    address_prefixes                           = ["10.8.7.96/27"]
    service_endpoints                          = ["Microsoft.Storage"]
    private_endpoint_network_policies_enabled  = true
    private_endpoint_service_endpoints_enabled = true
  },
  vm = {
    name                                       = "vm"
    address_prefixes                           = ["10.8.7.64/27"]
    service_endpoints                          = ["Microsoft.Storage"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true
  }
}
svcs_private_dns_zones                          = ["privatelink.vaultcore.azure.net"]
enable_forced_tunneling_on_svcs_route_table     = true
is_svcs_spoke_deployed_to_same_hub_subscription = true

#############################
## Peering Configuration  ###
#############################

use_remote_spoke_gateway = false

######################################
# 06 Shared Services Configuration  ##
######################################

# Azure Key Vault
enabled_for_deployment            = true
enabled_for_disk_encryption       = true
enabled_for_template_deployment   = true
rbac_authorization_enabled        = true
enable_key_vault_private_endpoint = true
admin_group_name                  = "azure-platform-owners"

# Bastion VM Configuration
windows_distribution_name = "windows2019dc"
virtual_machine_size      = "Standard_B1s"

# This module support multiple Pre-Defined windows and Windows Distributions.
# Check the README.md file for more pre-defined images for Ubuntu, Centos, RedHat.
# Please make sure to use gen2 images supported VM sizes if you use gen2 distributions
# Specify `disable_password_authentication = false` to create random admin password
# Specify a valid password with `admin_password` argument to use your own password .  
vm_admin_username = "azureuser"
instances_count   = 1

# Network Seurity group port definitions for each Virtual Machine 
# NSG association for all network interfaces to be added automatically.
nsg_inbound_rules = [
  {
    name                   = "ssh"
    destination_port_range = "22"
    source_address_prefix  = "*"
  },
]

# Attach a managed data disk to a Windows/windows virtual machine. 
# Storage account types include: #'Standard_LRS', #'StandardSSD_ZRS', #'Premium_LRS', #'Premium_ZRS', #'StandardSSD_LRS', #'UltraSSD_LRS' (UltraSSD_LRS is only accessible in regions that support availability zones).
# Create a new data drive - connect to the VM and execute diskmanagemnet or fdisk.
data_disks = [
  {
    name                 = "disk1"
    disk_size_gb         = 100
    storage_account_type = "StandardSSD_LRS"
  },
  {
    name                 = "disk2"
    disk_size_gb         = 200
    storage_account_type = "Standard_LRS"
  }
]

# Deploy log analytics agents on a virtual machine. 
# Customer id and primary shared key for Log Analytics workspace are required.
deploy_log_analytics_agent = true

###########################################
# 07 Web Workload Spoke Virtual Network ###
###########################################

wl_web_name               = "wl-web"
wl_web_vnet_address_space = ["10.8.8.0/24"]
wl_web_subnets = {
  default = {
    name                                       = "webapp"
    address_prefixes                           = ["10.8.8.192/27"]
    service_endpoints                          = ["Microsoft.Storage"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true
    nsg_subnet_inbound_rules = [
      # [name, description, priority, direction, access, protocol, destination_port_range, source_address_prefixes, destination_address_prefix]
      # Use "" for description to use default description
      # To use defaults, use [""] without adding any value and to use this subnet as a source or destination prefix.      
      ["Allow-Traffic-From-Spokes", "Allow traffic from spokes", "200", "Inbound", "Allow", "*", ["22", "80", "443", "3389"], ["10.8.7.0/24", "10.8.6.0/24"], ["10.8.8.0/24"]],
    ]
  },
  private-endpoints = {
    name                                       = "pe-webapp"
    address_prefixes                           = ["10.8.8.64/27"]
    service_endpoints                          = ["Microsoft.Storage"]
    private_endpoint_network_policies_enabled  = true
    private_endpoint_service_endpoints_enabled = true
  },
  vm = {
    name                                       = "vm-webapp"
    address_prefixes                           = ["10.8.8.96/27"]
    service_endpoints                          = ["Microsoft.Storage"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true
    nsg_subnet_inbound_rules = [
      # [name, description, priority, direction, access, protocol, destination_port_range, source_address_prefixes, destination_address_prefix]
      # Use "" for description to use default description
      # To use defaults, use [""] without adding any value and to use this subnet as a source or destination prefix.      
      ["Allow-3389", "Allow traffic from 3389", "200", "Inbound", "Allow", "*", ["3389"], [""], [""]],
    ]
  }
}
wl_web_private_dns_zones                          = ["privatelink.database.windows.net", "privatelink.azurewebsites.net", "privatelink.vaultcore.azure.net"]
enable_forced_tunneling_on_wl_web_route_table     = true
is_wl_web_spoke_deployed_to_same_hub_subscription = true

#############################
# 08 Workload App Service ###
#############################

# This is a sample configuration for App Service. 
app_service_workload_name = "wasw"
app_service_name          = "web-app-service-workload"
app_service_plan_sku_name = "I1v2"
enable_private_endpoint   = true
existing_private_dns_zone = "privatelink.vaultcore.azure.net"
create_app_service_plan   = true
deployment_slot_count     = 1
app_service_resource_type = "App"
app_service_plan_os_type  = "Windows"
windows_app_site_config = {
  always_on = true
  application_stack = {
    current_stack  = "dotnet"
    dotnet_version = "v6.0"
  }
  use_32_bit_worker        = false
  health_check_path        = "/health"
  ftps_state               = "Disabled"
  http2_enabled            = true
  http_logging_enabled     = true
  min_tls_version          = "1.2"
  remote_debugging_enabled = true
  websockets_enabled       = false
}
website_run_from_package      = "1"
app_service_plan_worker_count = 1

###################################
### 09 Azure SQL Configuations  ###
###################################


###################################
### 10 Frontdoor Configuations  ###
###################################
