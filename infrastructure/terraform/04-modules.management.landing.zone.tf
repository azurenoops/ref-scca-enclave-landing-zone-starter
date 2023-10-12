# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy an SCCA Compliant Platform Hub/Spoke Landing Zone. Management Hub network using the 
[Microsoft recommended Hub-Spoke network topology](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke). 
Usually, only one hub in each region with multiple spokes and each of the spokes can also be in separate subscriptions. 
This reference implementation will deploy a hub network with a two spokes network and all on one subscription.
DESCRIPTION: The following components will be options in this deployment
              * Hub Virtual Network (VNet)              
              * Bastion Host (Optional)
              * Microsoft Defender for Cloud (Optional)              
            * Spokes 
              * Identity             
              * Operations 
              * DevSecOps
            * Logging
              * Azure Sentinel
              * Azure Log Analytics
              * Azure Monitor
              * AMPLS (Azure Monitor Private Link Scope)
            * Azure Firewall
            * Private DNS Zones - Details of all the Azure Private DNS zones can be found here --> [https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration)
AUTHOR/S: jrspinella
*/

################################
### Hub/Spoke Configurations  ###
################################

#######################################
### Hub Network Configuration       ###
#######################################

module "mod_hub_network" {
  providers = { azurerm = azurerm.hub }
  source    = "azurenoops/overlays-management-hub/azurerm"
  version   = "~> 3.0"

  # By default, this module will create a resource group, provide the name here
  # To use an existing resource group, specify the existing resource group name, 
  # and set the argument to `create_resource_group = false`. Location will be same as existing RG.
  create_hub_resource_group = true
  location                  = var.default_location
  deploy_environment        = var.deploy_environment
  org_name                  = var.org_name
  environment               = var.environment
  workload_name             = var.hub_name

  # Logging
  # By default, Azure NoOps will create a Log Analytics Workspace in Hub VNet.
  log_analytics_workspace_sku          = var.log_analytics_workspace_sku
  log_analytics_logs_retention_in_days = var.log_analytics_logs_retention_in_days

  # Logging Solutions
  # All solutions are enabled (true) by default
  enable_sentinel              = var.enable_sentinel
  enable_azure_activity_log    = var.enable_azure_activity_log
  enable_vm_insights           = var.enable_vm_insights
  enable_azure_security_center = var.enable_azure_security_center
  enable_container_insights    = var.enable_container_insights
  enable_key_vault_analytics   = var.enable_key_vault_analytics
  enable_service_map           = var.enable_service_map

  # Provide valid VNet Address space and specify valid domain name for Private DNS Zone.  
  virtual_network_address_space           = var.hub_vnet_address_space              # (Required)  Hub Virtual Network Parameters  
  firewall_subnet_address_prefix          = var.fw_client_snet_address_prefixes     # (Required)  Hub Firewall Subnet Parameters  
  ampls_subnet_address_prefix             = var.ampls_subnet_address_prefixes       # (Required)  AMPLS Subnet Parameters
  firewall_management_snet_address_prefix = var.fw_management_snet_address_prefixes # (Optional)  Hub Firewall Management Subnet Parameters

  create_ddos_plan = var.create_ddos_plan # (Required)  DDoS Plan

  # (Required) Hub Subnets 
  # Default Subnets, Service Endpoints
  # This is the default subnet with required configuration, check README.md for more details
  # subnet name will be set as per Azure NoOps naming convention by default. expected value here is: <App or project name>
  hub_subnets = var.hub_subnets

  # Enable Flow Logs
  # By default, this will enable flow logs for all subnets.
  enable_traffic_analytics = var.enable_traffic_analytics

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
  firewall_network_rules_collection = var.firewall_network_rules

  # (Optional) specify the application rules for Azure Firewall
  # This is default values, do not need this if keeping default values
  firewall_application_rule_collection = var.firewall_application_rules

  # Private DNS Zone Settings
  # By default, Azure NoOps will create Private DNS Zones for Logging in Hub VNet.
  # If you do want to create additional Private DNS Zones, 
  # add in the list of private_dns_zones to be created.
  # else, remove the private_dns_zones argument.
  private_dns_zones = var.hub_private_dns_zones

  # By default, this module will create a bastion host, 
  # and set the argument to `enable_bastion_host = false`, to disable the bastion host.
  enable_bastion_host                 = var.enable_bastion_host
  azure_bastion_host_sku              = var.azure_bastion_host_sku
  azure_bastion_subnet_address_prefix = var.azure_bastion_subnet_address_prefix

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = var.enable_resource_locks

  # Tags
  add_tags = local.hub_resources_tags # Tags to be applied to all resources
}

#############################
### Spoke Configuration   ###
#############################

// Resources for the Operations Spoke
module "mod_id_network" {
  providers  = { azurerm = azurerm.identity, azurerm.hub_network = azurerm.hub }
  depends_on = [module.mod_hub_network]
  source     = "azurenoops/overlays-management-spoke/azurerm"
  version    = "~> 4.0"

  # By default, this module will create a resource group, provide the name here
  # To use an existing resource group, specify the existing resource group name, 
  # and set the argument to `create_resource_group = false`. Location will be same as existing RG.
  create_spoke_resource_group = true
  location                    = var.default_location
  deploy_environment          = var.deploy_environment
  org_name                    = var.org_name
  environment                 = var.environment
  workload_name               = var.id_name

  # Collect Hub Virtual Network Parameters
  # Hub network details to create peering and other setup
  hub_virtual_network_name        = module.mod_hub_network.virtual_network_name
  hub_firewall_private_ip_address = module.mod_hub_network.firewall_private_ip
  hub_resource_group_name         = module.mod_hub_network.resource_group_name

  # (Required) To enable Azure Monitoring and flow logs
  # pick the values for log analytics workspace which created by Spoke module
  # Possible retention values range between 30 and 730
  log_analytics_workspace_id           = module.mod_hub_network.management_logging_log_analytics_id
  log_analytics_customer_id            = module.mod_hub_network.management_logging_log_analytics_workspace_id # this is a issue in management module, need to fix. This should not have storage_account in the name
  log_analytics_logs_retention_in_days = 30

  # Provide valid VNet Address space for spoke virtual network.    
  virtual_network_address_space = var.id_vnet_address_space # (Required)  Spoke Virtual Network Parameters

  # (Required) Multiple Subnets, Service delegation, Service Endpoints, Network security groups
  # These are default subnets with required configuration, check README.md for more details
  # Route_table and NSG association to be added automatically for all subnets listed here.
  # subnet name will be set as per Azure naming convention by default. expected value here is: <App or project name>
  spoke_subnets = var.id_subnets

  # Enable Flow Logs
  # By default, this will enable flow logs for all subnets.
  enable_traffic_analytics = var.enable_traffic_analytics

  # By default, forced tunneling is enabled for the spoke.
  # If you do not want to enable forced tunneling on the spoke route table, 
  # set `enable_forced_tunneling = false`.
  enable_forced_tunneling_on_route_table = var.enable_forced_tunneling_on_id_route_table

  # Private DNS Zone Settings
  # By default, Azure NoOps will create Private DNS Zones for Logging in Hub VNet.
  # If you do want to create additional Private DNS Zones, 
  # add in the list of private_dns_zones to be created.
  # else, remove the private_dns_zones argument.
  private_dns_zones = var.id_private_dns_zones

  # Peering
  # By default, Azure NoOps will create peering between Hub and Spoke.
  # Since is using a gateway, set the argument to `use_source_remote_spoke_gateway = true`, to enable gateway traffic.   
  use_source_remote_spoke_gateway = var.use_remote_spoke_gateway

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = var.enable_resource_locks

  # Tags
  add_tags = local.identity_resources_tags # Tags to be applied to all resources
}

// Resources for the Operations Spoke
module "mod_ops_network" {
  providers  = { azurerm = azurerm.operations, azurerm.hub_network = azurerm.hub }
  depends_on = [module.mod_hub_network]
  source     = "azurenoops/overlays-management-spoke/azurerm"
  version    = "~> 4.0"

  # By default, this module will create a resource group, provide the name here
  # To use an existing resource group, specify the existing resource group name, 
  # and set the argument to `create_resource_group = false`. Location will be same as existing RG.
  create_spoke_resource_group = true
  location                    = var.default_location
  deploy_environment          = var.deploy_environment
  org_name                    = var.org_name
  environment                 = var.environment
  workload_name               = var.ops_name

  # Collect Hub Virtual Network Parameters
  # Hub network details to create peering and other setup
  hub_virtual_network_name        = module.mod_hub_network.virtual_network_name
  hub_firewall_private_ip_address = module.mod_hub_network.firewall_private_ip
  hub_resource_group_name         = module.mod_hub_network.resource_group_name

  # (Required) To enable Azure Monitoring and flow logs
  # pick the values for log analytics workspace which created by Spoke module
  # Possible retention values range between 30 and 730
  log_analytics_workspace_id           = module.mod_hub_network.management_logging_log_analytics_id
  log_analytics_customer_id            = module.mod_hub_network.management_logging_log_analytics_workspace_id # this is a issue in management module, need to fix. This should not have storage_account in the name
  log_analytics_logs_retention_in_days = 30

  # Provide valid VNet Address space for spoke virtual network.    
  virtual_network_address_space = var.ops_vnet_address_space # (Required)  Spoke Virtual Network Parameters

  # (Required) Multiple Subnets, Service delegation, Service Endpoints, Network security groups
  # These are default subnets with required configuration, check README.md for more details
  # Route_table and NSG association to be added automatically for all subnets listed here.
  # subnet name will be set as per Azure naming convention by default. expected value here is: <App or project name>
  spoke_subnets = var.ops_subnets

  # Enable Flow Logs
  # By default, this will enable flow logs for all subnets.
  enable_traffic_analytics = var.enable_traffic_analytics

  # By default, forced tunneling is enabled for the spoke.
  # If you do not want to enable forced tunneling on the spoke route table, 
  # set `enable_forced_tunneling = false`.
  enable_forced_tunneling_on_route_table = var.enable_forced_tunneling_on_ops_route_table

  # Private DNS Zone Settings
  # By default, Azure NoOps will create Private DNS Zones for Logging in Hub VNet.
  # If you do want to create additional Private DNS Zones, 
  # add in the list of private_dns_zones to be created.
  # else, remove the private_dns_zones argument.
  private_dns_zones = var.ops_private_dns_zones

  # Peering
  # By default, Azure NoOps will create peering between Hub and Spoke.
  # Since is using a gateway, set the argument to `use_source_remote_spoke_gateway = true`, to enable gateway traffic.   
  use_source_remote_spoke_gateway = var.use_remote_spoke_gateway

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = var.enable_resource_locks

  # Tags
  add_tags = local.operations_resources_tags # Tags to be applied to all resources
}

// Resources for the Shared Services Spoke
module "mod_devsecops_network" {
  providers  = { azurerm = azurerm.devsecops, azurerm.hub_network = azurerm.hub }
  depends_on = [module.mod_hub_network]
  source     = "azurenoops/overlays-management-spoke/azurerm"
  version    = "~> 4.0"

  # By default, this module will create a resource group, provide the name here
  # To use an existing resource group, specify the existing resource group name, 
  # and set the argument to `create_resource_group = false`. Location will be same as existing RG.
  create_spoke_resource_group = true
  location                    = var.default_location
  deploy_environment          = var.deploy_environment
  org_name                    = var.org_name
  environment                 = var.environment
  workload_name               = var.devsecops_name

  # Collect Hub Virtual Network Parameters
  # Hub network details to create peering and other setup
  hub_virtual_network_name        = module.mod_hub_network.virtual_network_name
  hub_firewall_private_ip_address = module.mod_hub_network.firewall_private_ip
  hub_resource_group_name         = module.mod_hub_network.resource_group_name

  # (Required) To enable Azure Monitoring and flow logs
  # pick the values for log analytics workspace which created by Spoke module
  # Possible values range between 30 and 730
  log_analytics_workspace_id           = module.mod_hub_network.management_logging_log_analytics_id
  log_analytics_customer_id            = module.mod_hub_network.management_logging_log_analytics_workspace_id # this is a issue in management module, need to fix
  log_analytics_logs_retention_in_days = 30

  # Provide valid VNet Address space for spoke virtual network.    
  virtual_network_address_space = var.devsecops_vnet_address_space # (Required)  Spoke Virtual Network Parameters

  # (Required) Multiple Subnets, Service delegation, Service Endpoints, Network security groups
  # These are default subnets with required configuration, check README.md for more details
  # Route_table and NSG association to be added automatically for all subnets listed here.
  # subnet name will be set as per Azure naming convention by default. expected value here is: <App or project name>
  spoke_subnets = var.devsecops_subnets

  # Enable Flow Logs
  # By default, this will enable flow logs for all subnets.
  enable_traffic_analytics = var.enable_traffic_analytics

  # By default, forced tunneling is enabled for the spoke.
  # If you do not want to enable forced tunneling on the spoke route table, 
  # set `enable_forced_tunneling = false`.
  enable_forced_tunneling_on_route_table = var.enable_forced_tunneling_on_devsecops_route_table

  # Private DNS Zone Settings
  # By default, Azure NoOps will create Private DNS Zones for Logging in Hub VNet.
  # If you do want to create additional Private DNS Zones, 
  # add in the list of private_dns_zones to be created.
  # else, remove the private_dns_zones argument.
  private_dns_zones = var.devsecops_private_dns_zones

  # Peering
  # By default, Azure NoOps will create peering between Hub and Spoke.
  # Since is using a gateway, set the argument to `use_source_remote_spoke_gateway = true`, to enable gateway traffic.   
  use_source_remote_spoke_gateway = var.use_remote_spoke_gateway

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = var.enable_resource_locks

  # Tags
  add_tags = local.devsecops_resources_tags # Tags to be applied to all resources
}


