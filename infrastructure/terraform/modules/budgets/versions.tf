# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy an SCCA Compliant Mission Partner Environment
DESCRIPTION: The following components will be options in this deployment
            * Mission Enclave - Management Groups and Subscriptions
              * Management Group
                * Org
                * Team
              * Subscription
                * Hub
                * Operations
                * Shared Services
                * Partner
                 * Global SA
AUTHOR/S: jspinella
*/

terraform {  
  backend "azurerm" {
    # resource_group_name  = ""   # Partial configuration, provided during "terraform init"
    # storage_account_name = ""   # Partial configuration, provided during "terraform init"
    # container_name       = ""   # Partial configuration, provided during "terraform init"
    key                    = "budgets"
  }
}

provider "azurerm" {
  features {}
}

