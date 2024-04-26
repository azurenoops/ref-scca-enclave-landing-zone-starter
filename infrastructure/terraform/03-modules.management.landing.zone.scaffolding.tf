# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
# Resource Group Creation
#----------------------------------------------------------
module "mod_hub_scaffold_rg" {
  source  = "azurenoops/overlays-resource-group/azurerm"
  version = "1.0.1"

  location                = module.mod_azregions_lookup.location_cli
  use_location_short_name = true # Use the short location name in the resource group name
  org_name                = var.org_name
  environment             = var.deploy_environment
  workload_name           = local.hub_short_name
  
  // Tags
  add_tags = local.hub_resources_tags
}

module "mod_id_scaffold_rg" {
  source  = "azurenoops/overlays-resource-group/azurerm"
  version = "1.0.1"

  location                = module.mod_azregions_lookup.location_cli
  use_location_short_name = true # Use the short location name in the resource group name
  org_name                = var.org_name
  environment             = var.deploy_environment
  workload_name           = local.identity_short_name
  
  // Tags
  add_tags = local.identity_resources_tags
}

module "mod_ops_scaffold_rg" {
  source  = "azurenoops/overlays-resource-group/azurerm"
  version = "1.0.1"

  location                = module.mod_azregions_lookup.location_cli
  use_location_short_name = true # Use the short location name in the resource group name
  org_name                = var.org_name
  environment             = var.deploy_environment
  workload_name           = local.operations_short_name
  
  // Tags
  add_tags = local.operations_resources_tags
}

module "mod_security_scaffold_rg" {
  source  = "azurenoops/overlays-resource-group/azurerm"
  version = "1.0.1"

  location                = module.mod_azregions_lookup.location_cli
  use_location_short_name = true # Use the short location name in the resource group name
  org_name                = var.org_name
  environment             = var.deploy_environment
  workload_name           = local.security_short_name
  
  // Tags
  add_tags = local.security_resources_tags
}

module "mod_devsecops_scaffold_rg" {
  source  = "azurenoops/overlays-resource-group/azurerm"
  version = "1.0.1"

  location                = module.mod_azregions_lookup.location_cli
  use_location_short_name = true # Use the short location name in the resource group name
  org_name                = var.org_name
  environment             = var.deploy_environment
  workload_name           = local.devsecops_short_name
  
  // Tags
  add_tags = local.devsecops_resources_tags
}