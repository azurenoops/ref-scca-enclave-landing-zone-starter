# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy Monitoring Service Alerts for Azure Service Health in Partner Environments
DESCRIPTION: The following components will be options in this deployment
             * Monitoring Service Alerts              
AUTHOR/S: jspinella
*/

##############################################
### Monitoring Service Alert Configuations ###
##############################################

# This module will create a monitoring service alerts on MPE resources
module "mod_service_health_monitoring" {  
  source   = "azurenoops/overlays-monitoring-service-alerts/azurerm"
  version  = "~> 0.1"

  for_each = var.service_alerts
  
  existing_resource_group_name = var.resource_group_name
  location                     = var.location
  org_name                     = var.org_name
  environment                  = var.environment
  deploy_environment           = var.deploy_environment
  workload_name                = var.workload_name

  action_group_short_name = var.action_group_short_name

  action_group_webhooks = var.action_group_webhooks

  activity_log_alerts = var.activity_log_alerts

  add_tags = {
    purpose = "${var.org_name} alerting"
  }
}

