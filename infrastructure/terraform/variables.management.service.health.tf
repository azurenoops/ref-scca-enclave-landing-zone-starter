# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

###############################
## Key Vault Configuration  ###
###############################

variable "enable_service_health_monitoring" {
  description = "Enable Service Health Monitoring"
  type        = bool
  default     = false
}

variable "action_group_short_name" {
  description = "Short name for the action group. Example: `alerting`."
  type        = string
  default     = "alerting"
}

variable "action_group_webhooks" {
  description = "Map of Webhooks to notify. Example: `{ PagerDuty = 'https://events.pagerduty.com/integration/abcdefgh12345azerty/enqueue' }`."
  type        = map(string)
  default     = {}
}

variable "action_group_emails" {
  description = "Map of Emails to notify. Example: `{ ml-devops = devops@contoso.com }`."
  type        = map(string)
  default     = {}
}

variable "activity_log_alerts" {
  description = "Map of Activity log Alerts."
  type = map(object({
    description         = optional(string)
    custom_name         = optional(string)
    resource_group_name = optional(string)
    scopes              = list(string)
    criteria = object({
      operation_name = optional(string)
      category       = optional(string, "Recommendation")
      level          = optional(string, "Error")
      status         = optional(string)

      resource_provider = optional(string)
      resource_type     = optional(string)
      resource_group    = optional(string)
      resource_id       = optional(string)
    })
  }))
  default = {}
}

variable "service_health" {
  description = "A block supports the following: `events`, `locations` and `services`. https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_activity_log_alert"
  type = object({
    events    = optional(string, "Incident")
    locations = optional(string, "Global")
    services  = optional(string)
  })
  default = null
}

variable "metric_alerts" {
  description = "Map of metric Alerts"
  type = map(object({
    custom_name              = optional(string, null)
    description              = optional(string, null)
    resource_group_name      = optional(string)
    scopes                   = optional(list(string), [])
    enabled                  = optional(bool, true)
    auto_mitigate            = optional(bool, true)
    severity                 = optional(number, 3)
    frequency                = optional(string, "PT5M")
    window_size              = optional(string, "PT5M")
    target_resource_type     = optional(string, null)
    target_resource_location = optional(string, null)

    tags = optional(map(string), {})

    criteria = optional(list(object({
      metric_namespace       = string
      metric_name            = string
      aggregation            = string
      operator               = string
      threshold              = number
      skip_metric_validation = optional(bool, false)
      dimension = optional(list(object({
        name     = string
        operator = optional(string, "Include")
        values   = list(string)
      })), [])
    })), [])

    dynamic_criteria = optional(list(object({
      metric_namespace         = string
      metric_name              = string
      aggregation              = string
      operator                 = string
      alert_sensitivity        = optional(string, "Medium")
      evaluation_total_count   = optional(number, 4)
      evaluation_failure_count = optional(number, 4)
      ignore_data_before       = optional(string)
      skip_metric_validation   = optional(bool, false)
      dimension = optional(list(object({
        name     = string
        operator = optional(string, "Include")
        values   = list(string)
      })), [])
    })), [])

    application_insights_web_test_location_availability_criteria = optional(object({
      web_test_id           = string
      component_id          = string
      failed_location_count = number
    }), null)
  }))

  default = {}
}