# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy the Identity Spoke in the Landing Zone
DESCRIPTION: The following components will be options in this deployment
             *  Identity Spoke Configuration
             *  Defender Configuration             
AUTHOR/S: jrspinella
*/

#####################################
### Identity Spoke Configuration  ###
#####################################

// Resources for the Operations Spoke
module "mod_id_network" {
  providers = { azurerm = azurerm.identity }
  source    = "azurenoops/overlays-management-spoke/azurerm"
  version   = "7.0.0-beta4"

  # By default, this module will create a resource group, provide the name here
  # To use an existing resource group, specify the existing_resource_group_name argument to the existing resource group, 
  # and set the argument to `create_spoke_resource_group = false`. Location will be same as existing RG.
  create_spoke_resource_group = true
  location                    = var.default_location
  deploy_environment          = var.deploy_environment
  org_name                    = var.org_name
  environment                 = var.environment
  workload_name               = local.identity_short_name

  # (Required) Collect Hub Firewall Parameters
  # Hub Firewall details
  existing_hub_firewall_private_ip_address = data.azurerm_firewall.hub-fw.ip_configuration[0].private_ip_address

  # Diagnostic settings for Vnet and Flow Logs
  existing_log_analytics_workspace_resource_id = data.azurerm_log_analytics_workspace.log_analytics.id
  existing_log_analytics_workspace_id          = data.azurerm_log_analytics_workspace.log_analytics.workspace_id

  # (Optional) Enable Customer Managed Key for Azure Storage Account
  enable_customer_managed_keys = var.enable_customer_managed_keys
  # Uncomment the following lines to enable Customer Managed Key for Azure Identity Storage Account
  # key_vault_resource_id               = module.mod_shared_keyvault.resource_id
  # key_name                            = "cmk-for-storage-account"
  # user_assigned_identity_id           = azurerm_user_assigned_identity.identity_user_assigned_identity.id
  # user_assigned_identity_principal_id = azurerm_user_assigned_identity.identity_user_assigned_identity.principal_id

  # (Optional) Enable User Assigned Identity for Azure Storage Account
  spoke_storage_user_assigned_resource_ids = [azurerm_user_assigned_identity.identity_user_assigned_identity.id]

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

  # CIDRs for Azure Log Storage Account
  # This will allow the specified CIDRs to bypass the Azure Firewall for Azure Storage Account.
  spoke_storage_bypass_ip_cidr           = var.id_storage_bypass_ip_cidrs
  spoke_storage_account_kind             = var.id_storage_account_kind
  spoke_storage_account_replication_type = var.id_storage_account_replication_type
  spoke_storage_account_tier             = var.id_storage_account_tier

  # (Optional) By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  # lock_level can be set to CanNotDelete or ReadOnly
  enable_resource_locks = var.enable_resource_locks
  lock_level            = var.lock_level

  # Tags
  add_tags = local.identity_resources_tags # Tags to be applied to all resources
}

#############################################
### VNet Peering Hub/Spoke Configuration  ###
#############################################

# Create VNet Peering between Hub and Identity VNets
module "mod_hub_to_id_vnet_peering" {
  providers = { azurerm = azurerm.identity }
  source    = "azurenoops/overlays-vnet-peering/azurerm"
  version   = "1.0.1"

  location           = var.default_location
  deploy_environment = var.deploy_environment
  org_name           = var.org_name
  environment        = var.environment
  workload_name      = local.identity_short_name

  # Vnet Peerings details
  enable_different_subscription_peering           = true
  resource_group_src_name                         = module.mod_id_network.resource_group_name
  different_subscription_dest_resource_group_name = module.mod_hub_network.resource_group_name //data.azurerm_virtual_network.hub-vnet.resource_group_name

  alias_subscription_id                                = var.subscription_id_hub
  vnet_src_name                                        = module.mod_id_network.virtual_network_name  //data.azurerm_virtual_network.id-vnet.name
  vnet_src_id                                          = module.mod_id_network.virtual_network_id    //data.azurerm_virtual_network.id-vnet.id
  different_subscription_dest_vnet_name                = module.mod_hub_network.virtual_network_name //data.azurerm_virtual_network.hub-vnet.name
  different_subscription_dest_vnet_id                  = module.mod_hub_network.virtual_network_id   //data.azurerm_virtual_network.hub-vnet.id
  use_remote_gateways_dest_vnet_different_subscription = var.use_remote_spoke_gateway
}

# Create a User Assigned Identity for Azure Encryption
resource "azurerm_user_assigned_identity" "identity_user_assigned_identity" {
  provider            = azurerm.identity
  location            = var.default_location
  resource_group_name = module.mod_id_network.resource_group_name
  name                = local.kv_cmk_id_user_assigned_identity_name
}

# Create a Role Assignment for the User Assigned Identity to the Key Vault for Azure Encryption
resource "azurerm_role_assignment" "identity_user_assigned_identity_role_assignment" {
  provider             = azurerm.identity
  depends_on           = [azurerm_user_assigned_identity.identity_user_assigned_identity]
  count                = var.enable_customer_managed_keys ? 1 : 0
  scope                = module.mod_shared_keyvault.resource_id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = azurerm_user_assigned_identity.identity_user_assigned_identity.principal_id
}
