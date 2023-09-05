# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Azure provider version 
terraform {
  # It is recommended to use remote state instead of local. Only use this if deploying the module only, and not from the root.
  #backend "azurerm" {
  # resource_group_name  = ""   # Partial configuration, provided during "terraform init"
  # storage_account_name = ""   # Partial configuration, provided during "terraform init"
  # container_name       = ""   # Partial configuration, provided during "terraform init"
  # key                    = "roles"
  # }
}

provider "azurerm" {
  skip_provider_registration = var.environment == "usgovernment" ? true : false
  features {}
}


