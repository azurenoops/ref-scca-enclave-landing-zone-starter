# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

terraform {
  required_version = "~> 1.3"
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = ">= 1.9.0, < 2.0.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}