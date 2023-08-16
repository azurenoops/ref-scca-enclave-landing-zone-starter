# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
  PARAMETERS
  Here are all the variables a user can override.
*/

#################################
# Global Sentinel Configuration
#################################

variable "sentinel_rule_alerts" {
  description = "A map of alerts to be created."
  type = map(object({
    query_frequency      = string
    query_period         = string
    severity             = string
    query                = string

   entity_mappings = list(object({
      entity_type = string
      field_name = string
      identifier     = string
    }))
    
    tactics = list(string)
    techniques           = list(string)

    display_name         = string
    description          = string
    enabled              = bool
    
    #Incident Configuration Block
    create_incident      = bool
    # Grouping Block in incident_configuration block
    grouping_enabled = bool
    lookback_duration       = string
    reopen_closed_incidents = bool
    entity_matching_method  = string
    group_by_entities       = list(string)
    group_by_alert_details  = list(string)

    suppression_duration = string
    suppression_enabled  = bool
    event_grouping = string
  }))
  default = {}
}