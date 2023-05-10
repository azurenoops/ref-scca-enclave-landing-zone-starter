# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy an SCCA Compliant Platform Hub/Spoke Landing Zone
DESCRIPTION: The following components will be options in this deployment
              * Hub Virtual Network (VNet)              
              * Bastion Host (Optional)
              * DDos Standard Plan (Optional)
              * Microsoft Defender for Cloud (Optional)              
            * Spokes              
              * Operations (Tier 1)
              * Shared Services (Tier 2)
            * Logging
              * Azure Sentinel
              * Azure Log Analytics
            * Azure Firewall
            * Private DNS Zones - Details of all the Azure Private DNS zones can be found here --> [https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration)
AUTHOR/S: jspinella
*/

################################
### Hub/Spoke Configuations  ###
################################

#######################################
### Hub Network Configuration       ###
#######################################

module "mod_hub_network" {
  providers = { azurerm = azurerm.hub }
  source    = "azurenoops/overlays-management-hub/azurerm"
  version   = ">= 1.0.0"

  #####################################
  ## Global Settings Configuration  ###
  #####################################

  # By default, this module will create a resource group, and set the argument to `create_resource_group = true`.
  # To use an existing resource group, specify the existing resource group name, 
  # and set the argument to `create_resource_group = false`. Location will be same as existing RG.
  create_resource_group = true
  location           = module.mod_azure_region_lookup.location_cli
  deploy_environment = var.deploy_environment
  org_name           = var.org_name
  environment        = var.environment
  workload_name      = var.hub_name

  #########################
  ## Hub Configuration  ###
  #########################

  # (Required)  Hub Virtual Network Parameters   
  # Provide valid VNet Address space and specify valid domain name for Private DNS Zone.  
  virtual_network_address_space           = var.hub_vnet_address_space    # (Required)  Hub Virtual Network Parameters  
  firewall_subnet_address_prefix          = var.fw_client_snet_address_prefixes   # (Required)  Hub Firewall Subnet Parameters  
  ampls_subnet_address_prefix             = var.ampls_subnet_address_prefix   # (Required)  AMPLS Subnet Parameters
  firewall_management_snet_address_prefix = var.fw_management_snet_address_prefixes # (Optional)  Hub Firewall Management Subnet Parameters
  gateway_subnet_address_prefix           = ["10.0.100.192/27"] # (Optional)  Hub Gateway Subnet Parameters
  
  # (Optional) Create DDOS Plan. Default is false
  create_ddos_plan = var.create_ddos_plan

  # (Optional) Hub Network Watcher
  create_network_watcher = var.create_network_watcher

  # (Required) Hub Subnets 
  # Default Subnets, Service Endpoints
  # This is the default subnet with required configuration, check README.md for more details
  # First address ranges from VNet Address space reserved for Firewall Subnets. 
  # ex.: For 10.0.100.128/27 address space, usable address range start from 10.0.100.0/24 for all subnets.
  # default subnet name will be set as per Azure NoOps naming convention by defaut.
  # Multiple Subnets, Service delegation, Service Endpoints, Network security groups
  # These are default subnets with required configuration, check README.md for more details
  # NSG association to be added automatically for all subnets listed here.
  # First two address ranges from VNet Address space reserved for Gateway And Firewall Subnets. 
  # ex.: For 10.1.0.0/16 address space, usable address range start from 10.1.2.0/24 for all subnets.
  # subnet name will be set as per Azure naming convention by defaut. expected value here is: <App or project name>
  hub_subnets = {
    default = {
      name                                       = "hub-core"
      address_prefixes                           = var.hub_subnet_addresses
      service_endpoints                          = var.hub_subnet_service_endpoints
      private_endpoint_network_policies_enabled  = false
      private_endpoint_service_endpoints_enabled = true
    }

    dmz = {
      name                                       = "app-gateway"
      address_prefixes                           = ["10.0.100.224/27"]
      service_endpoints                          = ["Microsoft.Storage"]
      private_endpoint_network_policies_enabled  = false
      private_endpoint_service_endpoints_enabled = true
      nsg_subnet_inbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefixes]
        # To use defaults, use "" without adding any value and to use this subnet as a source or destination prefix.
        # 65200-65335 port to be opened if you planning to create application gateway
        ["http", "100", "Inbound", "Allow", "Tcp", "80", "*", ["0.0.0.0/0"]],
        ["https", "200", "Inbound", "Allow", "Tcp", "443", "*", [""]],
        ["appgwports", "300", "Inbound", "Allow", "Tcp", "65200-65335", "*", [""]],

      ]
      nsg_subnet_outbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefixes]
        # To use defaults, use "" without adding any value and to use this subnet as a source or destination prefix.
        ["ntp_out", "400", "Outbound", "Allow", "Udp", "123", "", ["0.0.0.0/0"]],
      ]
    }
  }

  ########################################
  ## Management Logging Configuration  ###
  ########################################

  # By default, this will module will deploy management logging.
  # If you do not want to enable management logging, 
  # set enable_management_logging to false.
  # All Log solutions are enabled (true) by default. To disable a solution, set the argument to `enable_<solution_name> = false`.
  enable_management_logging = true
  log_analytics_workspace_sku = var.log_analytics_workspace_sku
  log_analytics_workspace_retention_in_days = var.log_analytics_workspace_retention_in_days

  ##############################
  ## Firewall Configuration  ###
  ##############################

  # Firewall Settings
  # By default, Azure NoOps will create Azure Firewall in Hub VNet. 
  # If you do not want to create Azure Firewall, 
  # set enable_firewall to false. This will allow different firewall products to be used (Example: F5).  
  enable_firewall = var.enable_firewall

  # By default, forced tunneling is enabled for Azure Firewall.
  # If you do not want to enable forced tunneling, 
  # set enable_forced_tunneling to false.
  enable_forced_tunneling = var.enable_forced_tunneling

  # (Optional) To enable the availability zones for firewall. 
  # Availability Zones can only be configured during deployment 
  # You can't modify an existing firewall to include Availability Zones
  firewall_zones = var.firewall_zones

  # # (Optional) specify the Network rules for Azure Firewall l
  # This is default values, do not need this if keeping default values
  firewall_network_rules_collection = var.network_rule_collection

  # (Optional) specify the application rules for Azure Firewall
  # This is default values, do not need this if keeping default values
  firewall_application_rule_collection = var.application_rule_collection

  #########################
  ## DNS Configuration  ###
  #########################

  # Private DNS Zone Settings
  # By default, Azure NoOps will create Private DNS Zones for Logging in Hub VNet.
  # If you do want to create addtional Private DNS Zones, 
  # add in the list of private_dns_zones to be created.
  # else, remove the private_dns_zones argument.
  private_dns_zones = ["privatelink.file.core.windows.net"]

  #############################
  ## Bastion Configuration  ###
  #############################

  # By default, this module will create a bastion host, 
  # and set the argument to `enable_bastion_host = false`, to disable the bastion host.
  enable_bastion_host                 = var.enable_bastion_host
  azure_bastion_host_sku              = var.bastion_host_sku
  azure_bastion_subnet_address_prefix = var.bastion_subnet_address_prefixes

  # Bastion Public IP
  azure_bastion_public_ip_allocation_method = "Static"
  azure_bastion_public_ip_sku               = "Standard"

  #############################
  ## Misc Configuration     ###
  #############################

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = var.enable_resource_locks

  # Tags
  add_tags = var.hub_resources_tags # Tags to be applied to all resources
}

#############################
### Spoke Configuration   ###
#############################

// Resources for the Operations Spoke
module "mod_ops_network" {
  depends_on = [
    module.mod_hub_network
  ]
  providers = { azurerm = azurerm.operations }
  source    = "azurenoops/overlays-management-spoke/azurerm"
  version   = ">= 1.0.0"

  #####################################
  ## Global Settings Configuration  ###
  #####################################

  location           = module.mod_azure_region_lookup.location_cli
  deploy_environment = var.deploy_environment
  org_name           = var.org_name
  environment        = var.environment
  workload_name      = var.ops_name

  ##################################################
  ## Operations Spoke Configuration   (Default)  ###
  ##################################################

  # Indicates if the spoke is deployed to the same subscription as the hub. Default is true.
  is_spoke_deployed_to_same_hub_subscription = var.deployed_to_hub_subscription

  # Provide valid VNet Address space for spoke virtual network.  
  virtual_network_address_space = var.ops_vnet_address_space

  # Provide valid subnet address prefix for spoke virtual network. Subnet naming is based on default naming standard
  spoke_subnet_address_prefix                         = var.ops_subnet_addresses
  spoke_subnet_service_endpoints                      = var.ops_subnet_service_endpoints
  spoke_private_endpoint_network_policies_enabled     = false
  spoke_private_link_service_network_policies_enabled = true

  # Hub Virtual Network ID
  hub_virtual_network_id = module.mod_hub_network.hub_virtual_network_id

  # Firewall Private IP Address 
  hub_firewall_private_ip_address = module.mod_hub_network.firewall_private_ip

  # (Optional) Enable forced tunneling for Route Table
  enable_forced_tunneling_on_route_table = true

  # (Optional) Operations Network Security Group
  # This is default values, do not need this if keeping default values
  # NSG rules are not created by default for Azure NoOps Hub Subnet

  # To deactivate default deny all rule
  deny_all_inbound = var.deny_all_inbound

  # Network Security Group Rules to apply to the Operatioms Virtual Network
  nsg_additional_rules = var.ops_nsg_rules

  #############################
  ## Misc Configuration     ###
  #############################

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = var.enable_resource_locks

  # Tags
  add_tags = var.operations_resources_tags # Tags to be applied to all resources
}

// Resources for the Shared Services Spoke
module "mod_svcs_network" {
  depends_on = [
    module.mod_hub_network
  ]
  providers = { azurerm = azurerm.sharedservices }
  source    = "azurenoops/overlays-hubspoke/azurerm//modules/virtual-network-spoke"
  version   = ">= 1.0.0"

  #####################################
  ## Global Settings Configuration  ###
  #####################################

  location           = module.mod_azure_region_lookup.location_cli
  deploy_environment = var.deploy_environment
  org_name           = var.org_name
  environment        = var.environment
  workload_name      = var.svcs_name

  #######################################################
  ## Shared Services Spoke Configuration   (Default)  ###
  #######################################################

  # Indicates if the spoke is deployed to the same subscription as the hub. Default is true.
  is_spoke_deployed_to_same_hub_subscription = var.deployed_to_hub_subscription

  # Provide valid VNet Address space for spoke virtual network.  
  virtual_network_address_space = var.svcs_vnet_address_space

  # Provide valid subnet address prefix for spoke virtual network. Subnet naming is based on default naming standard
  spoke_subnet_address_prefix                         = var.svcs_subnet_addresses
  spoke_subnet_service_endpoints                      = var.svcs_subnet_service_endpoints
  spoke_private_endpoint_network_policies_enabled     = false
  spoke_private_link_service_network_policies_enabled = true

  # Add Private Endpoint Subnet
  add_subnets = var.svcs_vnet_subnets

  # Hub Virtual Network ID
  hub_virtual_network_id = module.mod_hub_network.hub_virtual_network_id

  # Firewall Private IP Address 
  hub_firewall_private_ip_address = module.mod_hub_network.firewall_private_ip

  # (Optional) Enable forced tunneling for Route Table
  enable_forced_tunneling_on_route_table = true

  # (Optional) Shared Services Network Security Group
  # This is default values, do not need this if keeping default values
  # NSG rules are not created by default for Azure Nosvcs Hub Subnet

  # To deactivate default deny all rule
  deny_all_inbound = var.deny_all_inbound

  # Network Security Group Rules to apply to the Shared Services Virtual Network
  nsg_additional_rules = var.svcs_nsg_rules

  #############################
  ## Misc Configuration     ###
  #############################

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = var.enable_resource_locks

  # Tags
  add_tags = var.sharedservices_resources_tags # Tags to be applied to all resources
}

