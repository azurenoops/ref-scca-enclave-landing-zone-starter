# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

################################
### Hub/Spoke Configuations  ###
################################

module "mod_landing_zone" {
  source = "./modules/05-landing_zone"

  # Global Configuration
  location                   = var.default_location
  deploy_environment         = var.deploy_environment
  org_name                   = var.org_name
  environment                = var.environment
  subscription_id_hub        = var.subscription_id_hub
  subscription_id_operations = coalesce(var.subscription_id_operations, var.subscription_id_hub)
  subscription_id_identity   = coalesce(var.subscription_id_identity, var.subscription_id_hub)
  subscription_id_devsecops  = coalesce(var.subscription_id_devsecops, var.subscription_id_hub)

  # Resource Lock Configuration
  enable_resource_locks = var.enable_resource_locks
  lock_level            = var.lock_level

  # Operations Logging Configuration  
  ampls_subnet_address_prefix          = var.ampls_subnet_address_prefixes
  log_analytics_workspace_sku          = var.log_analytics_workspace_sku
  log_analytics_logs_retention_in_days = var.log_analytics_logs_retention_in_days

  # Operations Logging Solutions
  # All solutions are enabled (true) by default
  enable_sentinel              = var.enable_sentinel
  enable_azure_activity_log    = var.enable_azure_activity_log
  enable_vm_insights           = var.enable_vm_insights
  enable_azure_security_center = var.enable_azure_security_center
  enable_container_insights    = var.enable_container_insights
  enable_key_vault_analytics   = var.enable_key_vault_analytics
  enable_service_map           = var.enable_service_map

  # Hub Configuration
  hub_name               = var.hub_name
  hub_vnet_address_space = var.hub_vnet_address_space
  hub_subnets            = var.hub_subnets
  create_ddos_plan       = var.create_ddos_plan

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

  #Hub DNS Zones
  hub_private_dns_zones = var.hub_private_dns_zones

  #bastion
  enable_bastion_host                 = var.enable_bastion_host
  azure_bastion_host_sku              = var.azure_bastion_host_sku
  azure_bastion_subnet_address_prefix = var.azure_bastion_subnet_address_prefix

  # Identity Spoke Configuration
  id_name                                       = var.id_name
  id_vnet_address_space                         = var.id_vnet_address_space
  id_subnets                                    = var.id_subnets
  is_id_spoke_deployed_to_same_hub_subscription = var.is_id_spoke_deployed_to_same_hub_subscription
  enable_forced_tunneling_on_id_route_table     = var.enable_forced_tunneling_on_id_route_table
  id_private_dns_zones                          = var.id_private_dns_zones

  # Operations Spoke Configuration
  ops_name                                       = var.ops_name
  ops_vnet_address_space                         = var.ops_vnet_address_space
  ops_subnets                                    = var.ops_subnets
  is_ops_spoke_deployed_to_same_hub_subscription = var.is_ops_spoke_deployed_to_same_hub_subscription
  enable_forced_tunneling_on_ops_route_table     = var.enable_forced_tunneling_on_ops_route_table
  ops_private_dns_zones                          = var.ops_private_dns_zones

  # DevSecOps Spoke Configuration
  devsecops_name                                       = var.devsecops_name
  devsecops_vnet_address_space                         = var.devsecops_vnet_address_space
  devsecops_subnets                                    = var.devsecops_subnets
  is_devsecops_spoke_deployed_to_same_hub_subscription = var.is_devsecops_spoke_deployed_to_same_hub_subscription
  enable_forced_tunneling_on_devsecops_route_table     = var.enable_forced_tunneling_on_devsecops_route_table
  devsecops_private_dns_zones                          = var.devsecops_private_dns_zones

  # Peerings Configuration
  use_source_remote_spoke_gateway = var.use_remote_spoke_gateway

}


