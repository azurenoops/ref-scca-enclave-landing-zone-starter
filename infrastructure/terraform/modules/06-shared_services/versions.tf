# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }

  required_version = ">= 1.3"
}


provider "azurerm" {
  subscription_id = var.subscription_id_hub
  features {}
}
