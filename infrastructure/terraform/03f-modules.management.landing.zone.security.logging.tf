# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy the Security Logging in the Landing Zone
DESCRIPTION: The following components will be options in this deployment
             *  Security Logging Configuration
             *  Automation Account Configuration 
             *  Logging Configuration          
AUTHOR/S: jrspinella
*/

##########################################
#### Security Logging Configuration  ###
##########################################

module "mod_security_logging" {
  providers = { azurerm = azurerm.security }
  source  = "azurenoops/overlays-management-logging/azurerm"
  version = "3.5.0"

  #####################################
  ## Global Settings Configuration  ###
  #####################################

  create_resource_group = true
  location              = var.default_location
  deploy_environment    = var.deploy_environment
  org_name              = var.org_name
  environment           = var.environment
  workload_name         = "security-logging"

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
  log_analytics_logs_retention_in_days                       = var.log_analytics_security_logs_retention_in_days
  log_analytics_workspace_sku                                = var.log_analytics_workspace_sku

  # (Optional) Logging Solutions
  # All solutions are not enabled (false) by default
  enable_sentinel              = true # This is enabled by default
  enable_azure_activity_log    = var.enable_azure_activity_log
  enable_azure_security_center = var.enable_azure_security_center
  enable_service_map           = var.enable_service_map

  #############################
  ## Misc Configuration     ###
  #############################

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = var.enable_resource_locks
  lock_level = var.lock_level

  # Tags
  add_tags = {} # Tags to be applied to all resources
}
