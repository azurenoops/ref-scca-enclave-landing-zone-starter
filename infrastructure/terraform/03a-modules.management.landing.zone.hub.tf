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
            * Azure Firewall
            * Private DNS Zones - Details of all the Azure Private DNS zones can be found here --> [https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration)
AUTHOR/S: jrspinella
*/

#######################################
### Hub Network Configuration       ###
#######################################

module "mod_hub_network" {
  providers = { azurerm = azurerm.hub }
  source    = "azurenoops/overlays-management-hub/azurerm"
  version   = "7.6.0"

  depends_on = [module.mod_hub_scaffold_rg]

  # By default, this module will create a resource group, provide the name here
  # To use an existing resource group, specify the existing_resource_group_name argument to the existing resource group, 
  # and set the argument to `create_hub_resource_group = false`. Location will be same as existing RG.
  existing_resource_group_name = module.mod_hub_scaffold_rg.resource_group_name
  location                     = var.default_location
  deploy_environment           = var.deploy_environment
  org_name                     = var.org_name
  environment                  = var.environment
  workload_name                = local.hub_short_name

  # (Required) Provide valid VNet Address space for hub virtual network.
  # You can use the default values or provide your own values.  
  virtual_network_address_space           = var.hub_vnet_address_space              # (Required)  Hub Virtual Network Parameters  
  firewall_subnet_address_prefix          = var.fw_client_snet_address_prefixes     # (Required)  Hub Firewall Subnet Parameters  
  firewall_management_snet_address_prefix = var.fw_management_snet_address_prefixes # (Optional)  Hub Firewall Management Subnet Parameters
  
  # (Required) Log Analytics Workspace for Network Diagnostic Settings & Traffic Analytics
  log_analytics_workspace_resource_id = data.azurerm_log_analytics_workspace.log_analytics.id
  log_analytics_workspace_id          = data.azurerm_log_analytics_workspace.log_analytics.workspace_id

  # Blob Private DNS Id for Hub Storage Account
  # Change to meet environment requirements
  existing_private_dns_zone_blob_id = local.blob_pdns_id

  # (Optional) Enable DDos Protection Plan
  create_ddos_plan = var.create_ddos_plan

  # (Optional) Enable Customer Managed Key for Azure Storage Account
  enable_customer_managed_key = var.enable_customer_managed_keys
  # Uncomment the following lines to enable Customer Managed Key for Azure Hub Storage Account
  # key_vault_resource_id       = var.enable_customer_managed_keys ? module.mod_shared_keyvault.resource.id : null
  # key_name                    = var.enable_customer_managed_keys ? module.mod_shared_keyvault.resource_keys["cmk_for_storage_account"].name : null
  # user_assigned_identity_id   = var.enable_customer_managed_keys ? module.mod_managed_identity.id : null

  # (Required) Hub Subnets 
  # Default Subnets, Service Endpoints
  # This is the default subnet with required configuration, check README.md for more details
  # subnet name will be set as per Azure NoOps naming convention by default. expected value here is: <App or project name>
  hub_subnets = var.hub_subnets

  # (Optional) To enable NSG flow logs
  # By default, this will enable flow logs for all subnets.
  enable_traffic_analytics = var.enable_traffic_analytics

  # (Required) Firewall Settings
  # By default, Azure NoOps will create Azure Firewall in Hub VNet. 
  # If you do not want to create Azure Firewall, 
  # set enable_firewall to false. This will allow different firewall products to be used (Example: F5).  
  enable_firewall = var.enable_firewall

  # (Optional) By default, forced tunneling is enabled for Azure Firewall.
  # If you do not want to enable forced tunneling, 
  # set enable_forced_tunneling to false.
  enable_forced_tunneling = var.enable_forced_tunneling

  # (Optional) To enable the availability zones for firewall. 
  # Availability Zones can only be configured during deployment 
  # You can't modify an existing firewall to include Availability Zones
  firewall_zones = var.firewall_zones

  # (Optional) Service endpoints to add to the firewall client subnet
  firewall_snet_service_endpoints = local.fw_service_endpoints

  # DNS Servers for Firewall
  # By default, Azure NoOps will use Azure DNS for Azure Firewall DNS settings.
  # If you want to use custom DNS settings, set the argument to `enable_custom_dns_settings = true`.
  dns_servers = var.enable_dns_proxy ? var.dns_servers : []

  # # (Optional) specify the Network rules for Azure Firewall l
  # This is default values, do not need this if keeping default values
  firewall_network_rules_collection = var.firewall_network_rules

  # (Optional) specify the application rules for Azure Firewall
  # This is default values, do not need this if keeping default values
  firewall_application_rule_collection = var.firewall_application_rules

  # (Optional) By default, Azure NoOps will create Private DNS Zones for Logging in Hub VNet.
  # If you do want to create additional Private DNS Zones,
  # add in the list of private_dns_zones to be created.
  # else, remove the private_dns_zones argument.
  private_dns_zones = var.hub_private_dns_zones

  # (Optional) By default, this module will create a bastion host, 
  # and set the argument to `enable_bastion_host = false`, to disable the bastion host.
  enable_bastion_host                 = var.enable_bastion_host
  azure_bastion_host_sku              = var.azure_bastion_host_sku
  azure_bastion_subnet_address_prefix = var.azure_bastion_subnet_address_prefix

  # CIDRs for Azure Log Storage Account
  # This will allow the specified CIDRs to bypass the Azure Firewall for Azure Storage Account.
  hub_storage_bypass_ip_cidr = var.hub_storage_bypass_ip_cidrs

  # (Optional) By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = var.enable_resource_locks
  lock_level            = var.lock_level

  # Tags
  add_tags = local.hub_resources_tags # Tags to be applied to all resources
}
