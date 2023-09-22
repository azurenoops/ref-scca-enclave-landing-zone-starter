# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# The following random id is created once per module instantiation and is appended to the teleletry deployment name
resource "random_id" "telem" {
  count       = var.disable_telemetry ? 0 : 1
  byte_length = 4
}

# This is the core module telemetry deployment that is only created if telemetry is enabled.
# It is deployed to the default subscription
resource "azurerm_subscription_template_deployment" "telemetry_mgt_lz" {
  count            = local.telem_management_deployment_enabled ? 1 : 0
  provider         = azurerm
  name             = local.telem_management_arm_deployment_name
  location         = var.default_location
  template_content = local.telem_arm_subscription_template_content
}