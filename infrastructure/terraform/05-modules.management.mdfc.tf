# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy the Defender for Cloud in the Landing Zone
DESCRIPTION: The following components will be options in this deployment
             *  Defender Configuration             
AUTHOR/S: jrspinella
*/

################################
###  Defender Configuration  ###
################################

module "mod_microsoft_defender_for_cloud" {
  source    = "azurenoops/overlays-defender-for-cloud/azurerm"
  version   = "1.0.0"

  count = var.enable_defender_for_cloud ? 1 : 0

  # Global Settings Configuration
  security_center_contact_email = var.security_center_contact_email
  security_center_contact_phone = var.security_center_contact_phone

  # Defender Configuration
  security_center_pricing_tier           = var.security_center_pricing_tier
  security_center_pricing_resource_types = var.security_center_pricing_resource_types
  security_center_alert_notifications    = var.security_center_alert_notifications
  security_center_alerts_to_admins       = var.security_center_alerts_to_admins

  # Link to the Log Analytics Workspace
  security_center_workspaces = [
    {
      scope_id     = var.subscription_id_hub
      workspace_id = module.mod_logging.laws_resource_id
    },
    var.subscription_id_operations != null ? {
      scope_id     = var.subscription_id_operations
      workspace_id = module.mod_logging.laws_resource_id
    } : null,
    var.subscription_id_identity != null ? {
      scope_id     = var.subscription_id_identity
      workspace_id = module.mod_logging.laws_resource_id
    } : null,
    var.subscription_id_security != null ? {
      scope_id     = var.subscription_id_security
      workspace_id = module.mod_logging.laws_resource_id
    } : null,
    var.subscription_id_devsecops != null ? {
      scope_id     = var.subscription_id_devsecops
      workspace_id = module.mod_logging.laws_resource_id
    } : null,
  ]
}
