# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.32.0"
    }

  }

  # Use this backend for local development/testing
  #backend "azurerm" {
    # resource_group_name  = ""   # Partial configuration, provided during "terraform init"
    # storage_account_name = ""   # Partial configuration, provided during "terraform init"
    # container_name       = ""   # Partial configuration, provided during "terraform init"
    #key = "azure_sql"
  #}
}
