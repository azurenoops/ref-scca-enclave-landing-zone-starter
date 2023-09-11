# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
  PARAMETERS
  Here are all the variables a user can override.
*/

#################################
# Global Sentinel Configuration
#################################

variable "enable_sentinel_rule_alerts" {
  description = "Enable Sentinel Rule Alerts"
  type        = bool
  default     = false
}

variable "required_license_enabled" {
  description = "Enable Sentinel Data Connectors that require a license"
  type        = bool
  default     = false
}
variable "sentinel_rule_alerts" {
  description = "A map of alerts to be created."
  type = map(object({
    query_frequency = string
    query_period    = string
    severity        = string
    query           = string

    entity_mappings = list(object({
      entity_type = string
      field_name  = string
      identifier  = string
    }))

    tactics    = optional(list(string))
    techniques = optional(list(string))

    display_name = string
    description  = string
    enabled      = bool

    #Incident Configuration Block
    create_incident = bool
    # Grouping Block in incident_configuration block
    grouping_enabled        = optional(bool)
    lookback_duration       = optional(string)
    reopen_closed_incidents = optional(bool)
    entity_matching_method  = optional(string)
    group_by_entities       = optional(list(string))
    group_by_alert_details  = optional(list(string))

    suppression_duration = optional(string)
    suppression_enabled  = optional(bool)
    event_grouping       = optional(string)
  }))
  default = {}
}
