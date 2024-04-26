# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

data "azurenoopsutils_resource_name" "kv" {
  name          = var.keyvault_name
  resource_type = "azurerm_key_vault"
  prefixes      = [var.org_name, module.mod_azregions_lookup.location_short]
  suffixes      = compact([local.devsecops_short_name, var.deploy_environment])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "pe_kv_nic_name" {
  name          = var.keyvault_name
  resource_type = "azurerm_network_interface"
  prefixes      = [var.org_name, module.mod_azregions_lookup.location_short]
  suffixes      = compact([local.devsecops_short_name, var.deploy_environment, "pe"])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "pe_kv_psc_name" {
  name          = var.keyvault_name
  resource_type = "azurerm_private_service_connection"
  prefixes      = [var.org_name, module.mod_azregions_lookup.location_short]
  suffixes      = compact([local.devsecops_short_name, var.deploy_environment, "pe"])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "kv_diags_name" {
  name          = var.keyvault_name
  resource_type = "azurerm_custom_provider"
  prefixes      = [var.org_name, module.mod_azregions_lookup.location_short]
  suffixes      = compact([local.devsecops_short_name, var.deploy_environment, "pe", "diag"])
  use_slug      = false
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "pe_kv_name" {
  name          = var.keyvault_name
  resource_type = "azurerm_custom_provider"
  prefixes      = [var.org_name, module.mod_azregions_lookup.location_short]
  suffixes      = compact([local.devsecops_short_name, var.deploy_environment, "pe"])
  use_slug      = false
  clean_input   = true
  separator     = "-"
}

# Windows VM

data "azurenoopsutils_resource_name" "windows_jmp_name" {
  name          = "win-jmp"
  resource_type = "azurerm_windows_virtual_machine"
  prefixes      = [var.org_name, module.mod_azregions_lookup.location_short]
  suffixes      = compact([local.devsecops_short_name, var.deploy_environment])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "windows_nic_name" {
  name          = "win-jmp"
  resource_type = "azurerm_network_interface"
  prefixes      = [var.org_name, module.mod_azregions_lookup.location_short]
  suffixes      = compact([local.devsecops_short_name, var.deploy_environment])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}