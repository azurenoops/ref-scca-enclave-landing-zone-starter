# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

data "terraform_remote_state" "landing_zone" {
  backend = "azurerm"

  config = {
    storage_account_name = var.state_sa_name
    container_name       = var.state_sa_container_name
    key                  = "ampe"
    resource_group_name  = var.state_sa_rg
  }
}