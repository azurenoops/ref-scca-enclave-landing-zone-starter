# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy the Security Spoke in the Landing Zone
DESCRIPTION: The following components will be options in this deployment
             *  Security Spoke Configuration
             *  Defender Configuration             
AUTHOR/S: jrspinella
*/

#####################################
### Security Spoke Configuration  ###
#####################################

// Resources for the Security Spoke
module "mod_security_network" {
  providers = { azurerm = azurerm.security }
  source    = "azurenoops/overlays-management-spoke/azurerm"
  version   = "5.0.0"
  
  # By default, this module will create a resource group, provide the name here
  # To use an existing resource group, specify the existing_resource_group_name argument to the existing resource group, 
  # and set the argument to `create_spoke_resource_group = false`. Location will be same as existing RG.
  create_spoke_resource_group = true
  location                    = var.default_location
  deploy_environment          = var.deploy_environment
  org_name                    = var.org_name
  environment                 = var.environment
  workload_name               = var.ops_name

  # (Required) Collect Hub Firewall Parameters
  # Hub Firewall details
  existing_hub_firewall_private_ip_address = data.azurerm_firewall.hub-fw.ip_configuration[0].private_ip_address

  # Diagnostic settings for Vnet and Flow Logs
  existing_log_analytics_workspace_resource_id = data.azurerm_log_analytics_workspace.log_analytics.id
  existing_log_analytics_workspace_id          = data.azurerm_log_analytics_workspace.log_analytics.workspace_id

  # Blob Private DNS Id for Storage Account
  existing_private_dns_zone_blob_id = data.azurerm_private_dns_zone.blob.id

  # (Optional) Enable Customer Managed Key for Azure Storage Account
  enable_customer_managed_key = var.enable_customer_managed_keys
  key_vault_resource_id       = var.enable_customer_managed_keys ? module.mod_shared_keyvault.resource.id : null
  key_name                    = var.enable_customer_managed_keys ? module.mod_shared_keyvault.resource.keys["cmk_for_storage_account"].name : null

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

  # (Optional) By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  # lock_level can be set to CanNotDelete or ReadOnly
  enable_resource_locks = var.enable_resource_locks
  lock_level            = var.lock_level

  # Tags
  add_tags = local.operations_resources_tags # Tags to be applied to all resources
}
