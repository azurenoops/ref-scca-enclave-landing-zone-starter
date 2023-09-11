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

resource "azurerm_sentinel_data_connector_azure_active_directory" "dataAAD" {
  count = var.required_license_enabled ? 1 : 0
  name                       = "Azure_AD_Connector"
  log_analytics_workspace_id = module.mod_hub_network.managmement_logging_log_analytics_id
}

resource "azurerm_sentinel_data_connector_azure_security_center" "dataASC" {
  name                       = "Azure_Security_Center_Conector"
  log_analytics_workspace_id = module.mod_hub_network.managmement_logging_log_analytics_id
}

resource "azurerm_sentinel_data_connector_office_365" "dataO365" {
  count = var.required_license_enabled ? 1 : 0
  name                       = "O365_Connector"
  log_analytics_workspace_id = module.mod_hub_network.managmement_logging_log_analytics_id
  exchange_enabled           = true
  teams_enabled              = true
  sharepoint_enabled         = true
}

resource "azurerm_sentinel_data_connector_azure_advanced_threat_protection" "dataATP" {
  name                       = "ATP_Connector"
  log_analytics_workspace_id = module.mod_hub_network.managmement_logging_log_analytics_id
}

resource "azurerm_sentinel_data_connector_dynamics_365" "dataD365" {
  name                       = "D365_Connetor"
  log_analytics_workspace_id = module.mod_hub_network.managmement_logging_log_analytics_id
}

resource "azurerm_sentinel_data_connector_microsoft_cloud_app_security" "dataCAS" {
  count = var.required_license_enabled ? 1 : 0
  name                       = "CAS_Connector"
  log_analytics_workspace_id = module.mod_hub_network.managmement_logging_log_analytics_id
  alerts_enabled             = true
  discovery_logs_enabled     = true
}

resource "azurerm_sentinel_data_connector_microsoft_defender_advanced_threat_protection" "dataDATP" {
  count = var.required_license_enabled ? 1 : 0
  name                       = "DATP_Connector"
  log_analytics_workspace_id = module.mod_hub_network.managmement_logging_log_analytics_id
}

resource "azurerm_sentinel_data_connector_microsoft_threat_intelligence" "dataMTI" {
  name                                         = "MSTI_Connector"
  log_analytics_workspace_id                   = module.mod_hub_network.managmement_logging_log_analytics_id
  microsoft_emerging_threat_feed_lookback_date = "1970-01-01T00:00:00Z"
}

resource "azurerm_sentinel_data_connector_microsoft_threat_protection" "dataMTP" {
  name                       = "MTP_Connector"
  log_analytics_workspace_id = module.mod_hub_network.managmement_logging_log_analytics_id
}

resource "azurerm_sentinel_data_connector_office_365_project" "dataO365P" {
  count = var.required_license_enabled ? 1 : 0
  name                       = "O365P_Connector"
  log_analytics_workspace_id = module.mod_hub_network.managmement_logging_log_analytics_id
}

resource "azurerm_sentinel_data_connector_office_atp" "dataOATP" {
  count = var.required_license_enabled ? 1 : 0
  name                       = "OATP_Connector"
  log_analytics_workspace_id = module.mod_hub_network.managmement_logging_log_analytics_id
}

resource "azurerm_sentinel_data_connector_office_irm" "dataOIRM" {
  count = var.required_license_enabled ? 1 : 0
  name                       = "OIRM_Connector"
  log_analytics_workspace_id = module.mod_hub_network.managmement_logging_log_analytics_id
}

resource "azurerm_sentinel_data_connector_office_power_bi" "dataOPBI" {
  count = var.required_license_enabled ? 1 : 0
  name                       = "OPBI_Connector"
  log_analytics_workspace_id = module.mod_hub_network.managmement_logging_log_analytics_id
}

resource "azurerm_sentinel_data_connector_threat_intelligence" "dataTI" {
  name                       = "TI_Connector"
  log_analytics_workspace_id = module.mod_hub_network.managmement_logging_log_analytics_id
}

################################
###  Sentinel Configuations  ###
################################

module "mod_sentinel_rules" {
  source  = "azurenoops/overlays-sentinel-rules/azurerm//modules/scheduled-alert-rule"
  version = "~> 0.1"

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
}