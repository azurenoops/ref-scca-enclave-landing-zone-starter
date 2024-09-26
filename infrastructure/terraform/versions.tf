terraform {
  # It is recommended to use remote state instead of local
  #backend "local" {}
  # If you are using Azure Storage, You can update these values in order to configure your remote state. backend.conf is not required for local backend.
  backend "azurerm" { 
    resource_group_name  = "tse-usgva-hub-dev-state-rg"
    storage_account_name = "tseusgovhubdevstatest"
    container_name       = "tfstate"   
    key                  = "tse"
  }
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
    azurenoopsutils = {
      source  = "azurenoops/azurenoopsutils"
      version = "~> 1.0.4"
    }       
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id_hub
  environment     = var.environment
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
  storage_use_azuread = true
}

provider "azurerm" {
  alias           = "hub"
  subscription_id = var.subscription_id_hub
  environment     = var.environment
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
  storage_use_azuread = true
}

provider "azurerm" {
  alias           = "identity"
  subscription_id = coalesce(var.subscription_id_identity, var.subscription_id_hub)
  environment     = var.environment
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
  storage_use_azuread = true
}

provider "azurerm" {
  alias           = "operations"
  subscription_id = coalesce(var.subscription_id_operations, var.subscription_id_hub)
  environment     = var.environment
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
  storage_use_azuread = true
}

provider "azurerm" {
  alias           = "security"
  subscription_id = coalesce(var.subscription_id_security, var.subscription_id_hub)
  environment     = var.environment
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
  storage_use_azuread = true
}
/* UNCOMMENT IF YOU ARE USIMG FORENSICS SUB
/* provider "azurerm" {
  alias           = "forensic"
  subscription_id = coalesce(var.subscription_id_forensic, var.subscription_id_hub)
  environment     = var.environment
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
  storage_use_azuread = true
} */

provider "azurerm" {
  alias           = "devsecops"
  subscription_id = coalesce(var.subscription_id_devsecops, var.subscription_id_hub)
  environment     = var.environment
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
  storage_use_azuread = true
}
