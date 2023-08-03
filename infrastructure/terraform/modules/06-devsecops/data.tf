# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

data "azurerm_subnet" "devsecops_subnet" {
  name                 = "anoa-eus-devsecops-core-dev-default-snet"
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

data "azurerm_subnet" "devsecops_pe_subnet" {
  name                 = "anoa-eus-devsecops-core-dev-private-endpoints-snet"
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

data "azurerm_subnet" "devsecops_vm_subnet" {
  name                 = "anoa-eus-devsecops-core-dev-vm-snet"
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