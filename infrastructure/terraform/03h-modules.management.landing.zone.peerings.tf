# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy VNet Peering between Hub and Spoke VNets
DESCRIPTION: The following components will be options in this deployment
             * VNet Peering Configuration          
AUTHOR/S: jrspinella
*/

#############################################
### VNet Peering Hub/Spoke Configuration  ###
#############################################

# Create VNet Peering between Hub and Operations VNets
module "mod_hub_to_ops_vnet_peering" {
  source  = "azurenoops/overlays-vnet-peering/azurerm"
  version = "0.1.6-beta"

  location           = var.default_location
  deploy_environment = var.deploy_environment
  org_name           = var.org_name
  environment        = var.environment
  workload_name      = var.hub_name

  # Vnet Peerings details
  enable_different_subscription_peering           = true
  resource_group_src_name                         = module.mod_ops_network.resource_group_name
  different_subscription_dest_resource_group_name = module.mod_hub_network.resource_group_name

  alias_subscription_id                                = coalesce(var.subscription_id_operations, var.subscription_id_hub)
  vnet_src_name                                        = module.mod_hub_network.virtual_network_name
  vnet_src_id                                          = module.mod_hub_network.virtual_network_id
  different_subscription_dest_vnet_name                = module.mod_ops_network.virtual_network_name
  different_subscription_dest_vnet_id                  = module.mod_ops_network.virtual_network_id
  use_remote_gateways_dest_vnet_different_subscription = true
}


# Create VNet Peering between Hub and Identity VNets
module "mod_hub_to_id_vnet_peering" {
  source  = "azurenoops/overlays-vnet-peering/azurerm"
  version = "0.1.6-beta"

  location           = var.default_location
  deploy_environment = var.deploy_environment
  org_name           = var.org_name
  environment        = var.environment
  workload_name      = var.hub_name

  # Vnet Peerings details
  enable_different_subscription_peering           = true
  resource_group_src_name                         = module.mod_id_network.resource_group_name
  different_subscription_dest_resource_group_name = module.mod_hub_network.resource_group_name

  alias_subscription_id                                = coalesce(var.subscription_id_operations, var.subscription_id_hub)
  vnet_src_name                                        = module.mod_hub_network.virtual_network_name
  vnet_src_id                                          = module.mod_hub_network.virtual_network_id
  different_subscription_dest_vnet_name                = module.mod_id_network.virtual_network_name
  different_subscription_dest_vnet_id                  = module.mod_id_network.virtual_network_id
  use_remote_gateways_dest_vnet_different_subscription = true
}

# Create VNet Peering between Hub and DevSecOps VNets
module "mod_hub_to_devsecops_vnet_peering" {
  source  = "azurenoops/overlays-vnet-peering/azurerm"
  version = "0.1.6-beta"

  location           = var.default_location
  deploy_environment = var.deploy_environment
  org_name           = var.org_name
  environment        = var.environment
  workload_name      = var.hub_name

  # Vnet Peerings details
  enable_different_subscription_peering           = true
  resource_group_src_name                         = module.mod_devsecops_network.resource_group_name
  different_subscription_dest_resource_group_name = module.mod_hub_network.resource_group_name

  alias_subscription_id                                = coalesce(var.subscription_id_operations, var.subscription_id_hub)
  vnet_src_name                                        = module.mod_hub_network.virtual_network_name
  vnet_src_id                                          = module.mod_hub_network.virtual_network_id
  different_subscription_dest_vnet_name                = module.mod_devsecops_network.virtual_network_name
  different_subscription_dest_vnet_id                  = module.mod_devsecops_network.virtual_network_id
  use_remote_gateways_dest_vnet_different_subscription = true
}

# Create VNet Peering between Hub and Security VNets
module "mod_hub_to_security_vnet_peering" {
  source  = "azurenoops/overlays-vnet-peering/azurerm"
  version = "0.1.6-beta"

  location           = var.default_location
  deploy_environment = var.deploy_environment
  org_name           = var.org_name
  environment        = var.environment
  workload_name      = var.hub_name

  # Vnet Peerings details
  enable_different_subscription_peering           = true
  resource_group_src_name                         = module.mod_security_network.resource_group_name
  different_subscription_dest_resource_group_name = module.mod_hub_network.resource_group_name

  alias_subscription_id                                = coalesce(var.subscription_id_security, var.subscription_id_hub)
  vnet_src_name                                        = module.mod_hub_network.virtual_network_name
  vnet_src_id                                          = module.mod_hub_network.virtual_network_id
  different_subscription_dest_vnet_name                = module.mod_security_network.virtual_network_name
  different_subscription_dest_vnet_id                  = module.mod_security_network.virtual_network_id
  use_remote_gateways_dest_vnet_different_subscription = true
}
