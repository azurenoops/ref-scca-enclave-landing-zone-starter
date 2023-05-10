# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy an Mission Partner Environment Service Alerts
DESCRIPTION: The following components will be options in this deployment
              * Service Alerts
AUTHOR/S: jspinella
*/

# Configure the minimum required providers supported by this module
terraform { 
  backend "azurerm" {
    resource_group_name  = var.state_sa_rg
    storage_account_name = var.state_sa_name
    container_name       = var.state_sa_container_name
    key                  = "service_alerts"
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id_hub
  features {}
}