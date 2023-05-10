# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy an Azure Partner Environment
DESCRIPTION: The following components will be options in this deployment
             * Hub/Spoke Network Architecture
AUTHOR/S: jspinella
*/

################################
### Hub/Spoke Configuations  ###
################################

module "landing_zone" {
  source = "./modules/landing_zone"

  # Global Configuration
  required                       = var.required
  location                       = var.default_location
  subscription_id_hub            = var.subscription_id_hub
  subscription_id_operations     = coalesce(var.subscription_id_operations, var.subscription_id_hub)
  subscription_id_identity       = coalesce(var.subscription_id_identity, var.subscription_id_hub)
  subscription_id_sharedservices = coalesce(var.subscription_id_sharedservices, var.subscription_id_hub)
  state_sa_rg                    = local.state_sa_rg
  state_sa_name                  = local.state_sa_name
  state_sa_container_name        = local.state_sa_container_name

  # Resource Lock Configuration
  enable_resource_locks = var.enable_resource_locks
  lock_level            = var.lock_level

  # Operations Logging Configuration
  enable_management_logging                = var.enable_management_logging
  log_analytics_workspace_sku          = var.log_analytics_workspace_sku
  log_analytics_logs_retention_in_days = var.log_analytics_logs_retention_in_days

  # Hub Configuration
  hub_name                          = var.hub_name
  hub_vnet_address_space            = var.hub_vnet_address_space
  hub_vnet_subnet_address_prefixes  = var.hub_vnet_subnet_address_prefixes
  hub_vnet_subnet_service_endpoints = var.hub_vnet_subnet_service_endpoints
  enable_firewall                   = var.enable_firewall
  enable_force_tunneling            = var.enable_force_tunneling
  enable_bastion_host               = var.enable_bastion_host
  firewall_supernet_IP_address      = var.firewall_supernet_IP_address

  # Operations Spoke Configuration
  ops_name                          = var.ops_name
  ops_vnet_address_space            = var.ops_vnet_address_space
  ops_vnet_subnet_address_prefixes  = var.ops_vnet_subnet_address_prefixes
  ops_vnet_subnet_service_endpoints = var.ops_vnet_subnet_service_endpoints

  # Shared Services Spoke Configuration
  svcs_name                          = var.svcs_name
  svcs_vnet_address_space            = var.svcs_vnet_address_space
  svcs_vnet_subnet_address_prefixes  = var.svcs_vnet_subnet_address_prefixes
  svcs_vnet_subnet_service_endpoints = var.svcs_vnet_subnet_service_endpoints

}


