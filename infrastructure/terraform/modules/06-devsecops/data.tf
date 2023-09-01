# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

data "azurerm_subnet" "devsecops_pe_subnet" {
  name                 = var.existing_private_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

data "azurerm_subnet" "devsecops_vm_subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

data "azuread_group" "admin_group" {
  count = var.admin_group_name != null ? 1 : 0
  display_name = var.admin_group_name
}

data "azurerm_private_dns_zone" "kv_dns_zone" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resource_group_name
}