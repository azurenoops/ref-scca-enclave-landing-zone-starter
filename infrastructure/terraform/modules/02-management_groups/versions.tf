# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Azure provider version 
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 3.36"
    }
  }
  backend "azurerm" {
    # resource_group_name  = ""   # Partial configuration, provided during "terraform init"
    # storage_account_name = ""   # Partial configuration, provided during "terraform init"
    # container_name       = ""   # Partial configuration, provided during "terraform init"
    key                    = "management_groups"
  }
}

provider "azurerm" {    
    features {} 
}


