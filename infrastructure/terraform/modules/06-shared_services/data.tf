# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

data "azurerm_subnet" "svcs_subnet" {
  name                 = "anoa-eus-svcs-core-dev-default-snet"
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

data "azurerm_subnet" "svcs_vm_subnet" {
  name                 = "anoa-eus-svcs-core-dev-vm-snet"
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

data "azuread_group" "admin_group" {
  display_name = var.admin_group_name
}

data "azurerm_private_dns_zone" "kv_dns_zone" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resource_group_name
}