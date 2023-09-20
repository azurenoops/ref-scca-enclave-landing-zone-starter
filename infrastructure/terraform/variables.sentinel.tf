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

variable "sentinel_rule_alerts" {
  description = "A map of alerts to be created."
  type = map(object({
    query_frequency = string
    query_period    = string
    severity        = string
    query           = string

    entity_mappings = list(object({
      entity_type = string
      field_mappings = list(object({
        column_name = string
        identifier = string
      }))
    }))

    tactics    = optional(list(string))
    techniques = optional(list(string))

    display_name = string
    description  = string

    #Incident Configuration Block
    create_incident = bool
    # Grouping Block in incident_configuration block
    incident_configuration = object({
      enabled                 = bool
      lookback_duration       = string
      reopen_closed_incidents = bool
      entity_matching_method  = string
      group_by_entities       = list(string)
      group_by_alert_details  = list(string)
    })

    suppression_duration = optional(string)
    suppression_enabled  = optional(bool)
    event_grouping       = optional(string)
  }))
  default = {}
}
