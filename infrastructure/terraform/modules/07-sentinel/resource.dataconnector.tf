# # Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Sentinel Data Connectors
DESCRIPTION: This resource connects the Sentinel Data Connectors
AUTHOR/S: Curtis Slone / jrspinella
*//* 

resource "azurerm_sentinel_data_connector_azure_active_directory" "dataAAD" {
  name                       = "Azure_AD_Connector"
  log_analytics_workspace_id = var.log_analytics_ws_id
}

resource "azurerm_sentinel_data_connector_azure_security_center" "dataASC" {
  name                       = "Azure_Security_Center_Conector"
  log_analytics_workspace_id = var.log_analytics_ws_id
}

resource "azurerm_sentinel_data_connector_office_365" "dataO365" {
  name                       = "O365_Connector"
  log_analytics_workspace_id = var.log_analytics_ws_id
  exchange_enabled = true
  teams_enabled = true
  sharepoint_enabled = true
}

resource "azurerm_sentinel_data_connector_azure_advanced_threat_protection" "dataATP" {
  name                       = "ATP_Connector"
  log_analytics_workspace_id = var.log_analytics_ws_id
}

resource "azurerm_sentinel_data_connector_dynamics_365" "dataD365" {
  name                       = "D365_Connetor"
  log_analytics_workspace_id = var.log_analytics_ws_id
}

resource "azurerm_sentinel_data_connector_microsoft_cloud_app_security" "dataCAS" {
  name                       = "CAS_Connector"
  log_analytics_workspace_id = var.log_analytics_ws_id
  alerts_enabled = true
  discovery_logs_enabled = true
}

resource "azurerm_sentinel_data_connector_microsoft_defender_advanced_threat_protection" "dataDATP" {
  name                       = "DATP_Connector"
  log_analytics_workspace_id = var.log_analytics_ws_id
}

resource "azurerm_sentinel_data_connector_microsoft_threat_intelligence" "dataMTI" {
  name                                         = "MSTI_Connector"
  log_analytics_workspace_id = var.log_analytics_ws_id
  bing_safety_phishing_url_lookback_date       = "1970-01-01T00:00:00Z"
  microsoft_emerging_threat_feed_lookback_date = "1970-01-01T00:00:00Z"
}

resource "azurerm_sentinel_data_connector_microsoft_threat_protection" "dataMTP" {
  name                       = "MTP_Connector"
  log_analytics_workspace_id = var.log_analytics_ws_id
}

resource "azurerm_sentinel_data_connector_office_365_project" "dataO365P" {
  name                       = "O365P_Connector"
  log_analytics_workspace_id = var.log_analytics_ws_id
}

resource "azurerm_sentinel_data_connector_office_atp" "dataOATP" {
  name                       = "OATP_Connector"
  log_analytics_workspace_id = var.log_analytics_ws_id
}

resource "azurerm_sentinel_data_connector_office_irm" "dataOIRM" {
  name                       = "OIRM_Connector"
  log_analytics_workspace_id = var.log_analytics_ws_id
}

resource "azurerm_sentinel_data_connector_office_power_bi" "dataOPBI" {
  name                       = "OPBI_Connector"
  log_analytics_workspace_id = var.log_analytics_ws_id
}

resource "azurerm_sentinel_data_connector_threat_intelligence" "dataTI" {
  name                       = "TI_Connector"
  log_analytics_workspace_id = var.log_analytics_ws_id
  #lookback_date = "1970-01-01T00:00:00Z"
}

 */