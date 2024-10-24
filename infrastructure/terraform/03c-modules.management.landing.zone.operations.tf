# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy the Operations Spoke in the Landing Zone
DESCRIPTION: The following components will be options in this deployment
             *  Operations Spoke Configuration
             *  Defender Configuration
             * Operations Logging Configuration
              * Automation Account Configuration
              * Private Link Scope Configuration             
AUTHOR/S: jrspinella
*/

#######################################
### Operations Spoke Configuration  ###
#######################################

// Resources for the Operations Spoke
module "mod_ops_network" {
  providers = { azurerm = azurerm.operations }
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
  workload_name               = local.operations_short_name

  # (Required) Collect Hub Firewall Parameters
  # Hub Firewall details
  existing_hub_firewall_private_ip_address = data.azurerm_firewall.hub-fw.ip_configuration[0].private_ip_address

  # Diagnostic settings for Vnet and Flow Logs
  existing_log_analytics_workspace_resource_id = data.azurerm_log_analytics_workspace.log_analytics.id
  existing_log_analytics_workspace_id          = data.azurerm_log_analytics_workspace.log_analytics.workspace_id

  # (Optional) Enable Customer Managed Key for Azure Storage Account
  enable_customer_managed_keys = var.enable_customer_managed_keys
  # Uncomment the following lines to enable Customer Managed Key for Azure Operations Storage Account
  # key_vault_resource_id               = var.enable_customer_managed_keys ? module.mod_shared_keyvault.resource.id : null
  # key_name                            = var.enable_customer_managed_keys ? module.mod_shared_keyvault.resource_keys["cmk-for-storage-account"].name : null
  # user_assigned_identity_id           = azurerm_user_assigned_identity.operations_user_assigned_identity.id
  # user_assigned_identity_principal_id = azurerm_user_assigned_identity.operations_user_assigned_identity.principal_id

  # Enable User Assigned Identity for Azure Storage Account
  spoke_storage_user_assigned_resource_ids = [azurerm_user_assigned_identity.operations_user_assigned_identity.id]

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

  # CIDRs for Azure Log Storage Account
  # This will allow the specified CIDRs to bypass the Azure Firewall for Azure Storage Account.
  spoke_storage_bypass_ip_cidr           = var.ops_storage_bypass_ip_cidrs
  spoke_storage_account_kind             = var.ops_storage_account_kind
  spoke_storage_account_tier             = var.ops_storage_account_tier
  spoke_storage_account_replication_type = var.ops_storage_account_replication_type

  # (Optional) By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  # lock_level can be set to CanNotDelete or ReadOnly
  enable_resource_locks = var.enable_resource_locks
  lock_level            = var.lock_level

  # Tags
  add_tags = local.operations_resources_tags # Tags to be applied to all resources
}

#############################################
### VNet Peering Hub/Spoke Configuration  ###
#############################################

# Create VNet Peering between Hub and Operations VNets
module "mod_hub_to_ops_vnet_peering" {
  providers = { azurerm = azurerm.operations }
  source    = "azurenoops/overlays-vnet-peering/azurerm"
  version   = "1.0.1"

  location           = var.default_location
  deploy_environment = var.deploy_environment
  org_name           = var.org_name
  environment        = var.environment
  workload_name      = local.operations_short_name

  # Vnet Peerings details
  enable_different_subscription_peering           = true
  resource_group_src_name                         = module.mod_ops_network.resource_group_name
  different_subscription_dest_resource_group_name = module.mod_hub_network.resource_group_name //data.azurerm_virtual_network.hub-vnet.resource_group_name


  alias_subscription_id                                = var.subscription_id_hub
  vnet_src_name                                        = module.mod_ops_network.virtual_network_name //data.azurerm_virtual_network.ops-vnet.name
  vnet_src_id                                          = module.mod_ops_network.virtual_network_id   //data.azurerm_virtual_network.ops-vnet.id
  different_subscription_dest_vnet_name                = module.mod_hub_network.virtual_network_name //data.azurerm_virtual_network.hub-vnet.name
  different_subscription_dest_vnet_id                  = module.mod_hub_network.virtual_network_id   //data.azurerm_virtual_network.hub-vnet.id
  use_remote_gateways_dest_vnet_different_subscription = var.use_remote_spoke_gateway
}

##########################################
#### Operations Logging Configuration  ###
##########################################

module "mod_logging" {
  providers = { azurerm = azurerm.operations }
  source    = "azurenoops/overlays-management-logging/azurerm"
  version   = "4.0.1"

  #####################################
  ## Global Settings Configuration  ###
  #####################################

  create_resource_group = true
  location              = var.default_location
  deploy_environment    = var.deploy_environment
  org_name              = var.org_name
  environment           = var.environment
  workload_name         = local.operations_logging_name

  ########################################
  ## Automation Account Configuration  ###
  ########################################

  # Enable Automation Account Linking to Log Analytics Workspace
  enable_linked_automation_account_creation = var.enable_linked_automation_account_creation
  automation_account_sku_name               = var.automation_account_sku_name

  #############################
  ## Logging Configuration  ###
  #############################

  # Log Analytics Workspace Configuration
  log_analytics_workspace_allow_resource_only_permissions    = var.log_analytics_workspace_allow_resource_only_permissions
  log_analytics_workspace_cmk_for_query_forced               = var.log_analytics_workspace_cmk_for_query_forced
  log_analytics_workspace_daily_quota_gb                     = var.log_analytics_workspace_daily_quota_gb
  log_analytics_workspace_internet_ingestion_enabled         = var.log_analytics_workspace_internet_ingestion_enabled
  log_analytics_workspace_internet_query_enabled             = var.log_analytics_workspace_internet_query_enabled
  log_analytics_workspace_reservation_capacity_in_gb_per_day = var.log_analytics_workspace_reservation_capacity_in_gb_per_day # CapacityReservation is not supported in this configuration
  log_analytics_logs_retention_in_days                       = var.log_analytics_logs_retention_in_days
  log_analytics_workspace_sku                                = var.log_analytics_workspace_sku

  # (Optional) Logging Solutions
  # All solutions are not enabled (false) by default
  enable_sentinel              = false # This is not enabled by default, this is enabled in the security logging module
  enable_azure_activity_log    = var.enable_azure_activity_log
  enable_vm_insights           = var.enable_vm_insights
  enable_azure_security_center = var.enable_azure_security_center
  enable_service_map           = var.enable_service_map
  enable_container_insights    = var.enable_container_insights
  enable_key_vault_analytics   = var.enable_key_vault_analytics

  #############################
  ## Misc Configuration     ###
  #############################

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = var.enable_resource_locks
  lock_level            = var.lock_level

  # Tags
  add_tags = local.operations_resources_tags # Tags to be applied to all resources
}

#######################################
# Azure Monitor Private Link Scope   ##
#######################################

module "mod_ampls" {
  providers = { azurerm = azurerm.operations }
  source    = "azurenoops/overlays-azure-monitor-private-link-scope/azurerm"
  version   = "0.2.1"

  count = var.enable_ampls ? 1 : 0

  # Resource Group, location, VNet and Subnet details
  existing_resource_group_name = module.mod_ops_network.resource_group_name
  location                     = var.default_location
  deploy_environment           = var.deploy_environment
  environment                  = var.environment
  org_name                     = local.operations_logging_short_name

  # Log Analytics Workspaces
  linked_log_analytic_workspace_ids = [data.azurerm_log_analytics_workspace.log_analytics.id, module.mod_security_logging.laws_resource_id]

  # Private DNS details
  private_dns_zone_ids = [
    local.ampls_agentsvc_id,
    local.ampls_monitor_id,
    local.ampls_ods_id,
    local.ampls_oms_id,
    local.blob_pdns_id,
  ]

  # Private Endpoint details
  # VNet and Subnet details
  # This need to be the same as the VNet and Subnet where the Private Endpoint will be deployed
  existing_ampls_virtual_network_id = data.azurerm_virtual_network.ops-vnet.id
  existing_ampls_private_subnet_id  = module.mod_ops_network.subnet_ids["ampls"].id

  # Depends on the Ops RG module
  depends_on = [module.mod_ops_network]
}

# Create a User Assigned Identity for Azure Encryption
resource "azurerm_user_assigned_identity" "operations_user_assigned_identity" {
  provider            = azurerm.operations
  location            = var.default_location
  resource_group_name = module.mod_ops_network.resource_group_name
  name                = local.kv_cmk_ops_user_assigned_identity_name
}

# Create a Role Assignment for the User Assigned Identity to the Key Vault for Azure Encryption
resource "azurerm_role_assignment" "operations_user_assigned_identity_role_assignment" {
  provider             = azurerm.operations
  depends_on           = [azurerm_user_assigned_identity.operations_user_assigned_identity]
  count                = var.enable_customer_managed_keys ? 1 : 0
  scope                = module.mod_shared_keyvault.resource_id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = azurerm_user_assigned_identity.operations_user_assigned_identity.principal_id
}
