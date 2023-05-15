# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# The following block of locals are used to avoid using
# empty object types in the code
locals {
  empty_list   = []
  empty_map    = tomap({})
  empty_string = ""
}

# The following locals are used to define a set of module
# tags applied to all resources unless disabled by the
# input variable "disable_module_tags" and prepare the
# tag blocks for each sub-module
locals {
  base_module_tags = {
    deployedBy = "AzureNoOpsTF"
  }
  hub_resources_tags = merge(
    var.disable_base_module_tags ? local.empty_map : local.base_module_tags,
    var.default_tags,
  )
  operations_resources_tags = merge(
    var.disable_base_module_tags ? local.empty_map : local.base_module_tags,
    var.default_tags,
  )
  sharedservices_resources_tags = merge(
    var.disable_base_module_tags ? local.empty_map : local.base_module_tags,
    var.default_tags,
  )
}