# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

provider "azurerm" {
  subscription_id = var.subscription_id_hub
  skip_provider_registration = var.environment == "usgovernment" ? true : false
  features {}
}