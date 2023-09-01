terraform {
  # It is recommended to use remote state instead of local
  backend "local" {}
  # If you are using Azure Storage, You can update these values in order to configure your remote state. backend.conf is not required for local backend.
  #backend "azurerm" {    
  #  key                  = "anoa"
  #}
  # If you are using Terraform Cloud, You can update these values in order to configure your remote state.
  /*  backend "remote" {
    organization = "{{ORGANIZATION_NAME}}"
    workspaces {
      name = "{{WORKSPACE_NAME}}"
    }
  }
  */

  required_version = ">= 1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.36"
    }
    null = {
      source = "hashicorp/null"
    }
    random = {
      version = "= 3.4.3"
      source  = "hashicorp/random"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.8.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = var.environment == "usgovernment" ? true : false
  features {}
}