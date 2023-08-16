# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
  PARAMETERS
  Here are all the variables a user can override.
*/

variable "enable_sentinel_rule_alerts" {
    description = "Enable Sentinel Rule Alerts"
    type = bool
    default = false
}

variable "log_analytics_ws_id" {
    description = "Log Analytics workspace id for onboarding"
    type = string
    default = ""
}