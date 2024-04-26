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
  version = "1.0.0"

  azure_region = var.default_location
}

# Azure Regions Data
module "az_regions" {
  source  = "Azure/regions/azurerm"
  version = "0.6.0"
}

# Get SKU for VMs
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

# DNS Data Source Lookups
data "azurerm_private_dns_zone" "vault" {
  depends_on          = [module.mod_hub_network]
  provider            = azurerm.hub
  name                = var.environment == "public" ? "privatelink.vaultcore.azure.net" : "privatelink.vaultcore.azure.us"
  resource_group_name = module.mod_hub_network.private_dns_zone_resource_group_name
}

data "azurerm_private_dns_zone" "blob" {
  depends_on          = [module.mod_hub_network]
  provider            = azurerm.hub
  name                = var.environment == "public" ? "privatelink.blob.core.windows.net" : "privatelink.blob.core.usgovcloudapi.net"
  resource_group_name = module.mod_hub_network.private_dns_zone_resource_group_name
}

# AMPLS Data Source Lookups
data "azurerm_private_dns_zone" "agentsvc" {
  count               = var.enable_ampls ? 1 : 0
  depends_on          = [module.mod_hub_network]
  provider            = azurerm.hub
  name                = var.environment == "public" ? "privatelink.agentsvc.azure-automation.net" : "privatelink.agentsvc.azure-automation.us"
  resource_group_name = module.mod_hub_network.private_dns_zone_resource_group_name
}

data "azurerm_private_dns_zone" "monitor" {
  count               = var.enable_ampls ? 1 : 0
  depends_on          = [module.mod_hub_network]
  provider            = azurerm.hub
  name                = var.environment == "public" ? "privatelink.monitor.azure.com" : "privatelink.monitor.azure.us"
  resource_group_name = module.mod_hub_network.private_dns_zone_resource_group_name
}

data "azurerm_private_dns_zone" "ods" {
  count               = var.enable_ampls ? 1 : 0
  depends_on          = [module.mod_hub_network]
  provider            = azurerm.hub
  name                = var.environment == "public" ? "privatelink.ods.opinsights.azure.com" : "privatelink.ods.opinsights.azure.us"
  resource_group_name = module.mod_hub_network.private_dns_zone_resource_group_name
}

data "azurerm_private_dns_zone" "oms" {
  count               = var.enable_ampls ? 1 : 0
  depends_on          = [module.mod_hub_network]
  provider            = azurerm.hub
  name                = var.environment == "public" ? "privatelink.oms.opinsights.azure.com" : "privatelink.oms.opinsights.azure.us"
  resource_group_name = module.mod_hub_network.private_dns_zone_resource_group_name
}

# Hub Data Lookups
data "azurerm_virtual_network" "hub-vnet" {
  depends_on          = [module.mod_hub_network]
  provider            = azurerm.hub
  name                = module.mod_hub_network.virtual_network_name
  resource_group_name = module.mod_hub_network.resource_group_name
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

# Identity Data Lookups
data "azurerm_virtual_network" "id-vnet" {
  depends_on          = [module.mod_id_network]
  provider            = azurerm.identity
  name                = module.mod_id_network.virtual_network_name
  resource_group_name = module.mod_id_network.resource_group_name
}

# Operations Data Lookups
data "azurerm_virtual_network" "ops-vnet" {
  depends_on          = [module.mod_ops_network]
  provider            = azurerm.operations
  name                = module.mod_ops_network.virtual_network_name
  resource_group_name = module.mod_ops_network.resource_group_name
}

data "azurerm_subnet" "ops-ampls-snet" {
  depends_on           = [module.mod_ops_network]
  provider             = azurerm.operations
  name                 = module.mod_ops_network.subnet_names["ampls"].name
  virtual_network_name = module.mod_ops_network.virtual_network_name
  resource_group_name  = module.mod_ops_network.resource_group_name
}

# Security Data Lookups
data "azurerm_virtual_network" "sec-vnet" {
  depends_on          = [module.mod_security_network]
  provider            = azurerm.security
  name                = module.mod_security_network.virtual_network_name
  resource_group_name = module.mod_security_network.resource_group_name
}

data "azurerm_log_analytics_workspace" "sec_log_analytics" {
  depends_on          = [module.mod_security_network]
  provider            = azurerm.security
  name                = module.mod_security_logging.laws_name
  resource_group_name = module.mod_security_logging.laws_rgname
}

# DevSecOps Data Lookups
data "azurerm_virtual_network" "devsecops-vnet" {
  depends_on          = [module.mod_devsecops_network]
  provider            = azurerm.devsecops
  name                = module.mod_devsecops_network.virtual_network_name
  resource_group_name = module.mod_devsecops_network.resource_group_name
}

data "azurerm_subnet" "devsecops-default-snet" {
  depends_on           = [module.mod_devsecops_network]
  provider             = azurerm.devsecops
  name                 = module.mod_devsecops_network.subnet_names["default"].name
  virtual_network_name = module.mod_devsecops_network.virtual_network_name
  resource_group_name  = module.mod_devsecops_network.resource_group_name
}

data "azurerm_storage_account" "devsecops-storage" {
  depends_on          = [module.mod_devsecops_network]
  provider            = azurerm.devsecops
  name                = module.mod_devsecops_network.storage_account_name
  resource_group_name = module.mod_devsecops_network.resource_group_name
}