# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
  PARAMETERS
  Here are all the variables a user can override.
*/

################################
# Landing Zone Configuration  ##
################################

#########################
# Management Logging  ###
#########################

variable "linked_log_analytic_workspace_ids" {
  description = "The IDs of the Log Analytics Workspaces to link to the Private Link Scope."
  type        = list(string)
  default     = []
}

variable "log_analytics_workspace_sku" {
  description = "[Free/Standard/Premium/PerNode/PerGB2018/Standalone] The SKU for the Log Analytics Workspace. It defaults to 'PerGB2018'. See https://docs.microsoft.com/en-us/azure/azure-monitor/logs/resource-manager-workspace for valid settings."
  type        = string
  default     = "PerGB2018"
}

variable "log_analytics_logs_retention_in_days" {
  description = "The number of days to retain Log Analytics Workspace logs without Sentinel. It defaults to '30'."
  type        = number
  default     = 30
}

variable "log_analytics_security_logs_retention_in_days" {
  description = "The number of days to retain Log Analytics Workspace logs with Sentinel. It defaults to '30'."
  type        = number
  default     = 30
}

variable "log_analytics_workspace_reservation_capacity_in_gb_per_day" {
  description = "The daily ingestion quota in GB for the Log Analytics Workspace. Default is 200."
  type        = number
  default     = 200
}

variable "log_analytics_workspace_daily_quota_gb" {
  description = "The daily quota for Log Analytics Workspace logs in Gigabytes. It defaults to '-1' for no quota."
  type        = number
  default     = 1
}

variable "log_analytics_workspace_allow_resource_only_permissions" {
  type        = bool
  default     = true
  description = "Specifies whether the Log Analytics Workspace should only allow access to resources within the same subscription. Defaults to true."
}

variable "log_analytics_workspace_cmk_for_query_forced" {
  type        = bool
  default     = true
  description = "Specifies whether the Log Analytics Workspace should force the use of Customer Managed Keys for query. Defaults to true."
}

variable "log_analytics_workspace_internet_ingestion_enabled" {
  type        = bool
  default     = false
  description = "Should the Log Analytics Workspace support ingestion over the Public Internet? Defaults to true."
}

variable "log_analytics_workspace_internet_query_enabled" {
  type        = bool
  default     = true
  description = "Should the Log Analytics Workspace support querying over the Public Internet? Defaults to true."
}

variable "enable_ampls" {
  description = "Enable Azure Monitor Private Link Scope. Default is false."
  type        = bool
  default     = false  
}

#####################################
# Log Solutions Configuration     ##
#####################################

variable "enable_azure_activity_log" {
  description = "When set to 'true', enables Azure Activity Log within the Log Analytics Workspace created in this deployment. It defaults to 'false'."
  type        = bool
  default     = false
}

variable "enable_vm_insights" {
  description = "When set to 'true', enables Virtual Machine Insights within the Log Analytics Workspace created in this deployment. It defaults to 'false'."
  type        = bool
  default     = false
}

variable "enable_azure_security_center" {
  description = "When set to 'true', enables Azure Security Center within the Log Analytics Workspace created in this deployment. It defaults to 'false'."
  type        = bool
  default     = false
}

variable "enable_service_map" {
  description = "When set to 'true', enables Service Map within the Log Analytics Workspace created in this deployment. It defaults to 'false'."
  type        = bool
  default     = false
}

variable "enable_container_insights" {
  description = "When set to 'true', enables Container Insights within the Log Analytics Workspace created in this deployment. It defaults to 'false'."
  type        = bool
  default     = false
}

variable "enable_key_vault_analytics" {
  description = "When set to 'true', enables Key Vault Analytics within the Log Analytics Workspace created in this deployment. It defaults to 'false'."
  type        = bool
  default     = false
}

#######################################
# Automation Account Configuration   ##
#######################################

variable "enable_automation_account_user_assigned_identity" {
  description = "Controls if a Managed Identity should be created for the Automation Account. Default is false."
  type        = bool
  default     = false
}

variable "enable_automation_account_encryption" {
  description = "Controls if encryption should be enabled for the Automation Account. Default is false."
  type        = bool
  default     = false
}

variable "enable_automation_account_local_authentication" {
  description = "Controls if local authentication should be enabled for the Automation Account. Default is true."
  type        = bool
  default     = true
}

variable "enable_automation_account_public_network_access" {
  description = "Controls if public network access should be enabled for the Automation Account. Default is true."
  type        = bool
  default     = true
}

variable "automation_account_sku_name" {
  description = "The SKU of the Automation Account. Possible values are Basic, Free, and Standard. Default is Basic."
  type        = string
  default     = "Basic"
}

variable "enable_linked_automation_account_creation" {
  description = "Controls if a linked Automation Account should be created. Default is true."
  type        = bool
  default     = true
}

variable "enable_linked_automation_account" {
  description = "Controls if a linked Automation Account should be created. Default is true."
  type        = bool
  default     = true
}

variable "automation_account_key_vault_key_id" {
  description = "The ID of the Key Vault Key to use for Automation Account encryption."
  type        = string
  default     = null
}

variable "automation_account_key_vault_url" {
  description = "The URL of the Key Vault to use for Automation Account encryption."
  type        = string
  default     = null
}