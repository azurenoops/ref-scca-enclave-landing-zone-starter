# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy Monitoring Service Alerts for Azure Service Health in the Hub
DESCRIPTION: The following components will be options in this deployment
             * Monitoring Service Alerts              
AUTHOR/S: jrspinella
*/

##############################################
### Monitoring Service Alert Configurations ###
##############################################

# This module will create a monitoring service alerts on MPE resources
module "mod_service_health_monitoring" {
  source  = "azurenoops/overlays-monitoring-service-alerts/azurerm"
  version = "0.1.0"

  count = var.enable_service_health_monitoring ? 1 : 0

  create_alerts_resource_group = true
  location                     = var.default_location
  org_name                     = var.org_name
  environment                  = var.environment
  deploy_environment           = var.deploy_environment
  workload_name                = "alerting"

  action_group_short_name = var.action_group_short_name

  action_group_webhooks = var.action_group_webhooks

  activity_log_alerts = {
    "service-health" = {
      description = "Service Health global Subscription alerts"
      scopes      = ["${local.provider_path.subscriptions}${var.subscription_id_hub}"]
      criteria = {
        category = "ServiceHealth"
      }
    },
    "security-center" = {
      custom_name = "service-health-global-security-center"
      description = "Security Center global Subscription alerts"
      scopes      = ["${local.provider_path.subscriptions}${var.subscription_id_hub}"]
      criteria = {
        category = "Security"
        level    = "Error"
      }
    },
    "advisor" = {
      custom_name = "service-health-global-advisor-alerts"
      description = "Advisor global Subscription alerts"
      scopes      = ["${local.provider_path.subscriptions}${var.subscription_id_hub}"]
      criteria = {
        category = "Recommendation"
        level    = "Informational"
      }
    }
  }

  add_tags = merge(local.base_module_tags, var.default_tags, {
    purpose = "${var.org_name} alerting"
  })
}
