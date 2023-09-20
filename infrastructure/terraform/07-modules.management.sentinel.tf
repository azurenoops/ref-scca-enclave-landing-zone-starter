# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Sentinel DAta Connectors & Alerts
DESCRIPTION: This resource generates sentinel alerts based on the alert rules input into the module
AUTHOR/S: jrspinella
*/

##################################################
###  Sentinel Data Connections Configuations  ###
##################################################

/* module "mod_sentinel_dataAAD" {
  source                     = "azurenoops/overlays-sentinel/azurerm//modules/sentinel_connectors/aad"
  version                    = "~> 1.0"
  log_analytics_workspace_id = module.mod_hub_network.managmement_logging_log_analytics_id
}

module "mod_sentinel_dataASC" {
  source                     = "azurenoops/overlays-sentinel/azurerm//modules/sentinel_connectors/asc"
  version                    = "~> 1.0"
  log_analytics_workspace_id = module.mod_hub_network.managmement_logging_log_analytics_id
}

module "mod_sentinel_dataATP" {
  source                     = "azurenoops/overlays-sentinel/azurerm//modules/sentinel_connectors/atp"
  version                    = "~> 1.0"
  log_analytics_workspace_id = module.mod_hub_network.managmement_logging_log_analytics_id
} */

################################
###  Sentinel Configuations  ###
################################

/* module "mod_sentinel_rules" {
  source  = "azurenoops/overlays-sentinel/azurerm//modules/scheduled_alert_rule"
  version = "~> 1.0"

  depends_on = [module.mod_hub_network]

  for_each = var.enable_sentinel_rule_alerts ? var.sentinel_rule_alerts : {}

  display_name               = each.key
  log_analytics_workspace_id = module.mod_hub_network.managmement_logging_log_analytics_id
  description                = each.value.description
  query_frequency            = each.value.query_frequency
  query_period               = each.value.query_period
  severity                   = each.value.severity
  query                      = each.value.query
  entity_mappings            = each.value.entity_mappings
  tactics                    = each.value.tactics
  techniques                 = each.value.techniques
  enabled                    = each.value.incident_configuration.enabled
  create_incident            = each.value.create_incident
  reopen_closed_incidents    = each.value.incident_configuration.reopen_closed_incidents
  lookback_duration          = each.value.incident_configuration.lookback_duration
  entity_matching_method     = each.value.incident_configuration.entity_matching_method
  group_by_entities          = each.value.incident_configuration.group_by_entities
  group_by_alert_details     = each.value.incident_configuration.group_by_alert_details
  suppression_duration       = each.value.suppression_duration
  suppression_enabled        = each.value.suppression_enabled
  aggregation_method         = each.value.event_grouping
} */
