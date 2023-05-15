# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy an Azure Budgets for a Partner Environment
DESCRIPTION: The following components will be options in this deployment
             * Budgets
AUTHOR/S: jspinella
*/

#################################
### App Service Configuations ###
#################################

module "mod_app_service" {
  source  = "azurenoops/overlays-app-service/azurerm"
  version = ">= 1.0.0"

  existing_resource_group_name = var.resource_group_name
  location                     = var.location
  deploy_environment           = var.deploy_environment
  org_name                     = var.org_name
  environment                  = var.environment
  workload_name                = var.workload_name

  enable_private_endpoint       = var.enable_private_endpoint
  existing_private_dns_zone     = var.existing_private_dns_zone
  app_service_name              = var.app_service_name
  private_endpoint_subnet_name  = var.private_endpoint_subnet_name
  app_service_plan_sku_name     = var.app_service_plan_sku_name
  create_app_service_plan       = var.create_app_service_plan
  deployment_slot_count         = var.deployment_slot_count
  app_service_plan_os_type      = var.app_service_plan_os_type
  app_service_resource_type     = var.app_service_resource_type
  windows_app_site_config       = var.site_config
  website_run_from_package      = var.website_run_from_package
  app_service_plan_worker_count = var.app_service_plan_worker_count

  # Tags
  add_tags = var.default_tags # Tags to be applied to all resources
}
