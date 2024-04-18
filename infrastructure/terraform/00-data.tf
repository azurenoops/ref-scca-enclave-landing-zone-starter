# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
  DATA
  Here are all the data sources used in the landing zone.
*/

# Get the current Azure Client Configuration
data "azurerm_client_config" "root" {}

# This module will lookup the Azure Region and return the short name for the region
module "mod_azregions_lookup" {
  source  = "azurenoops/overlays-azregions-lookup/azurerm"
  version = "~> 1.0.0"

  azure_region = var.default_location
}

module "get_valid_sku_for_deployment_region" {
  source            = "./modules/vm_sku_selector"
  deployment_region = var.default_location
}

# Get current IP address for use in KV firewall rules
data "http" "ip" {
  url = "https://api.ipify.org/"
  retry {
    attempts     = 5
    max_delay_ms = 1000
    min_delay_ms = 500
  }
}

# Data Source Lookups
data "azurerm_private_dns_zone" "vault" {
  depends_on          = [module.mod_hub_network]
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = module.mod_hub_network.private_dns_zone_resource_group_name
}

data "azurerm_private_dns_zone" "blob" {
  depends_on          = [module.mod_hub_network]
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = module.mod_hub_network.private_dns_zone_resource_group_name
}

data "azurerm_firewall" "hub-fw" {
  depends_on          = [module.mod_hub_network]
  provider            = azurerm.hub
  name                = module.mod_hub_network.firewall_name
  resource_group_name = module.mod_hub_network.resource_group_name
}

data "azurerm_log_analytics_workspace" "log_analytics" {
  depends_on          = [module.mod_logging]
  provider            = azurerm.operations
  name                = module.mod_logging.laws_name
  resource_group_name = module.mod_logging.laws_rgname
}
