# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# The following block of locals are used to avoid using
# empty object types in the code
locals {
  empty_list   = []
  empty_map    = tomap({})
  empty_string = ""
}

# The following locals are used to control time_sleep
# delays between resources to reduce transient errors
# relating to replication delays in Azure
locals {
  create_duration_delay = {
    after_azurerm_management_group = var.create_duration_delay["azurerm_management_group"]
  }
  destroy_duration_delay = {
    after_azurerm_management_group = var.destroy_duration_delay["azurerm_management_group"]
  }
}
