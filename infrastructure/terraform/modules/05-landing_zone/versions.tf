# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id_hub
  skip_provider_registration = var.environment == "usgovernment" ? true : false
  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = var.provider_azurerm_features_keyvault.permanently_delete_on_destroy
    }
    key_vault {
      purge_soft_delete_on_destroy = var.provider_azurerm_features_keyvault.purge_soft_delete_on_destroy
    }
    resource_group {
      prevent_deletion_if_contains_resources = var.provider_azurerm_features_resource_group.prevent_deletion_if_contains_resources # When that feature flag is set to true, this is required to stop the deletion of the resource group when the deployment is destroyed. This is required if the resource group contains resources that are not managed by Terraform.
    }
  }
}

provider "azurerm" {
  alias           = "hub"
  subscription_id = var.subscription_id_hub
  skip_provider_registration = var.environment == "usgovernment" ? true : false
  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = var.provider_azurerm_features_keyvault.permanently_delete_on_destroy
    }
    key_vault {
      purge_soft_delete_on_destroy = var.provider_azurerm_features_keyvault.purge_soft_delete_on_destroy
    }
    resource_group {
      prevent_deletion_if_contains_resources = var.provider_azurerm_features_resource_group.prevent_deletion_if_contains_resources # When that feature flag is set to true, this is required to stop the deletion of the resource group when the deployment is destroyed. This is required if the resource group contains resources that are not managed by Terraform.
    }
  }
}

provider "azurerm" {
  alias           = "identity"
  subscription_id = coalesce(var.subscription_id_identity, var.subscription_id_hub)
  skip_provider_registration = var.environment == "usgovernment" ? true : false
  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = var.provider_azurerm_features_keyvault.permanently_delete_on_destroy
    }
    key_vault {
      purge_soft_delete_on_destroy = var.provider_azurerm_features_keyvault.purge_soft_delete_on_destroy
    }
    resource_group {
      prevent_deletion_if_contains_resources = var.provider_azurerm_features_resource_group.prevent_deletion_if_contains_resources # When that feature flag is set to true, this is required to stop the deletion of the resource group when the deployment is destroyed. This is required if the resource group contains resources that are not managed by Terraform.
    }
  }
}

provider "azurerm" {
  alias           = "operations"
  subscription_id = coalesce(var.subscription_id_operations, var.subscription_id_hub)
  skip_provider_registration = var.environment == "usgovernment" ? true : false
  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = var.provider_azurerm_features_keyvault.permanently_delete_on_destroy
    }
    key_vault {
      purge_soft_delete_on_destroy = var.provider_azurerm_features_keyvault.purge_soft_delete_on_destroy
    }
    resource_group {
      prevent_deletion_if_contains_resources = var.provider_azurerm_features_resource_group.prevent_deletion_if_contains_resources # When that feature flag is set to true, this is required to stop the deletion of the resource group when the deployment is destroyed. This is required if the resource group contains resources that are not managed by Terraform.
    }
  }
}

provider "azurerm" {
  alias           = "devsecops"
  subscription_id = coalesce(var.subscription_id_devsecops, var.subscription_id_hub)
  skip_provider_registration = var.environment == "usgovernment" ? true : false
  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = var.provider_azurerm_features_keyvault.permanently_delete_on_destroy
    }
    key_vault {
      purge_soft_delete_on_destroy = var.provider_azurerm_features_keyvault.purge_soft_delete_on_destroy
    }
    resource_group {
      prevent_deletion_if_contains_resources = var.provider_azurerm_features_resource_group.prevent_deletion_if_contains_resources # When that feature flag is set to true, this is required to stop the deletion of the resource group when the deployment is destroyed. This is required if the resource group contains resources that are not managed by Terraform.
    }
  }
}
