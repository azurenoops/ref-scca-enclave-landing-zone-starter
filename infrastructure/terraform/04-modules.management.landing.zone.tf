# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

################################
### Hub/Spoke Configuations  ###
################################

module "landing_zone" {
  source = "./modules/05-landing_zone"

  # Global Configuration
  location                       = var.default_location
  deploy_environment             = var.deploy_environment
  org_name                       = var.org_name
  environment                    = var.environment
  subscription_id_hub            = var.subscription_id_hub
  subscription_id_operations     = coalesce(var.subscription_id_operations, var.subscription_id_hub)
  subscription_id_identity       = coalesce(var.subscription_id_identity, var.subscription_id_hub)
  subscription_id_sharedservices = coalesce(var.subscription_id_sharedservices, var.subscription_id_hub)

  # Resource Lock Configuration
  enable_resource_locks = var.enable_resource_locks
  lock_level            = var.lock_level

  # Operations Logging Configuration  
  ampls_subnet_address_prefix          = var.ampls_subnet_address_prefixes
  log_analytics_workspace_sku          = var.log_analytics_workspace_sku
  log_analytics_logs_retention_in_days = var.log_analytics_logs_retention_in_days

  # Hub Configuration
  hub_name               = var.hub_name
  hub_vnet_address_space = var.hub_vnet_address_space
  hub_subnets            = var.hub_subnets

  #flog Logs
  enable_traffic_analytics = var.enable_traffic_analytics

  #firewall
  enable_firewall                     = var.enable_firewall
  firewall_supernet_IP_address        = var.firewall_supernet_IP_address
  fw_client_snet_address_prefixes     = var.fw_client_snet_address_prefixes
  fw_management_snet_address_prefixes = var.fw_management_snet_address_prefixes
  firewall_zones                      = var.firewall_zones
  firewall_application_rules          = var.firewall_application_rules
  firewall_network_rules              = var.firewall_network_rules
  firewall_nat_rules                  = var.firewall_nat_rules
  enable_forced_tunneling             = var.enable_forced_tunneling
  gateway_vnet_address_space          = var.gateway_vnet_address_space

  #dns_zones
  

  #bastion
  enable_bastion_host                 = var.enable_bastion_host
  azure_bastion_host_sku              = var.azure_bastion_host_sku
  azure_bastion_subnet_address_prefix = var.azure_bastion_subnet_address_prefix

  # Operations Spoke Configuration
  ops_name                                       = var.ops_name
  ops_vnet_address_space                         = var.ops_vnet_address_space
  ops_subnets                                    = var.ops_subnets
  is_ops_spoke_deployed_to_same_hub_subscription = var.is_ops_spoke_deployed_to_same_hub_subscription
  enable_forced_tunneling_on_ops_route_table     = var.enable_forced_tunneling_on_ops_route_table
  ops_private_dns_zones                          = var.ops_private_dns_zones

  # Shared Services Spoke Configuration
  svcs_name                                       = var.svcs_name
  svcs_vnet_address_space                         = var.svcs_vnet_address_space
  svcs_subnets                                    = var.svcs_subnets
  is_svcs_spoke_deployed_to_same_hub_subscription = var.is_svcs_spoke_deployed_to_same_hub_subscription
  enable_forced_tunneling_on_svcs_route_table     = var.enable_forced_tunneling_on_svcs_route_table
  svcs_private_dns_zones                          = var.svcs_private_dns_zones

  # Peerings Configuration
  use_source_remote_spoke_gateway = var.use_remote_spoke_gateway

}


