# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy Azure Operations Logging for a Hub/Spoke Landing Zone
DESCRIPTION: The following components will be options in this deployment
             * Operations Logging Configuration
              * Automation Account Configuration
              * Private Link Scope Configuration
AUTHOR/S: jrspinella
*/

##########################################
#### Operations Logging Configuration  ###
##########################################

module "mod_logging" {
  providers = { azurerm = azurerm.operations }
  source    = "azurenoops/overlays-management-logging/azurerm"
  version   = "3.5.0"

  #####################################
  ## Global Settings Configuration  ###
  #####################################

  create_resource_group = true
  location              = var.default_location
  deploy_environment    = var.deploy_environment
  org_name              = var.org_name
  environment           = var.environment
  workload_name         = "logging"

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

  # Add linked Log Analytics Workspace to Private Link Scope
  # This is only if you want to link the Log Analytics Workspace to the Private Link Scope
  # beyond the default linked workspace attached to the logging module.
  linked_log_analytic_workspace_ids = [module.mod_security_logging.laws_resource_id]

  # AMPLS Configuration  
  # (Optional) To enable Azure Monitoring Private Link Scope
  # Enable Azure Monitor Private Link Scope
  # Uncomment the following block to enable Azure Monitor Private Link Scope.
  # Add this when Operations network is deployed and you want to enable AMPLS
  /* enable_ampls = var.enable_ampls

  ampls_subnet_address_prefix          = var.ampls_subnet_address_prefixes
  existing_network_resource_group_name = module.mod_ops_network.resource_group_name
  existing_virtual_network_name        = module.mod_ops_network.virtual_network_name */

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = var.enable_resource_locks
  lock_level            = var.lock_level

  # Tags
  add_tags = {} # Tags to be applied to all resources
}
