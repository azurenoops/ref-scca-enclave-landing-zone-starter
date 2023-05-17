# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#####################################
### Workload Spoke Configuations  ###
#####################################

module "mod_workload_spoke" {
  source = "./modules/07-workload_spoke"

  # Global Configuration
  location                 = var.default_location
  deploy_environment       = var.deploy_environment
  org_name                 = var.org_name
  environment              = var.environment
  subscription_id_workload = data.azurerm_client_config.current.subscription_id #var.subscription_id_workload_dev Change this to the subscription ID of the workload subscription

  # Hub Configuration
  hub_virtual_network_id = module.mod_landing_zone.hub_virtual_network_id
  firewall_private_ip    = module.mod_landing_zone.firewall_private_ip
  hub_storage_account_id = module.mod_landing_zone.hub_storage_account_id
  hub_managmement_logging_log_analytics_id = module.mod_landing_zone.ops_logging_log_analytics_resource_id
  hub_managmement_logging_workspace_id = module.mod_landing_zone.ops_logging_log_analytics_workspace_id

  # Resource Lock Configuration
  enable_resource_locks = var.enable_resource_locks
  lock_level            = var.lock_level

  #flog Logs
  enable_traffic_analytics = var.enable_traffic_analytics

  # Workload Spoke Configuration
  wl_name                                       = var.wl_name
  wl_vnet_address_space                         = var.wl_vnet_address_space
  wl_subnets                                    = var.wl_subnets
  is_wl_spoke_deployed_to_same_hub_subscription = var.is_wl_spoke_deployed_to_same_hub_subscription
  enable_forced_tunneling_on_wl_route_table     = var.enable_forced_tunneling_on_wl_route_table
  wl_private_dns_zones                          = var.wl_private_dns_zones

  # Peerings Configuration
  use_source_remote_spoke_gateway = var.use_remote_spoke_gateway

}
