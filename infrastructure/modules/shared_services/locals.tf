# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# The following block of locals are used to avoid using
# empty object types in the code
locals {
  empty_list   = []
  empty_map    = tomap({})
  empty_string = ""
}

# The following locals are used to convert provided input
# variables to locals before use elsewhere in the module
locals {
  subscription_id_hub   = var.subscription_id_hub
  org_name              = var.required.org_name
  deploy_environment    = var.required.deploy_environment
  environment           = var.required.environment
  metadata_host         = var.required.metadata_host
  enable_resource_locks = var.enable_resource_locks
  default_location      = var.location
  default_tags          = var.default_tags
  disable_telemetry     = var.disable_telemetry
}

# The following locals are used to convert provided input
# variables to locals before use elsewhere in the key vault module
locals {
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_private_endpoint         = true
}

# The following locals are used to convert provided input
# variables to locals before use elsewhere in the bastion vm module
locals {
  enable_bastion_host = var.enable_bastion_host
}

# The following locals are used to define RegEx
# patterns used within this module
locals {
  # The following regex is designed to consistently
  # split a resource_id into the following capture
  # groups, regardless of resource type:
  # [0] Resource scope, type substring (e.g. "/providers/Microsoft.Management/managementGroups/")
  # [1] Resource scope, name substring (e.g. "group1")
  # [2] Resource, type substring (e.g. "/providers/Microsoft.Authorization/policyAssignments/")
  # [3] Resource, name substring (e.g. "assignment1")
  regex_split_resource_id         = "(?i)((?:/[^/]+){0,8}/)?([^/]+)?((?:/[^/]+){3}/)([^/]+)$"
  regex_scope_is_management_group = "(?i)(/providers/Microsoft.Management/managementGroups/)([^/]+)$"
  # regex_scope_is_subscription     = "(?i)(/subscriptions/)([^/]+)$"
  # regex_scope_is_resource_group   = "(?i)(/subscriptions/[^/]+/resourceGroups/)([^/]+)$"
  # regex_scope_is_resource         = "(?i)(/subscriptions/[^/]+/resourceGroups(?:/[^/]+){4}/)([^/]+)$"
}

# The following locals are used to define a set of module
# tags applied to all resources unless disabled by the
# input variable "disable_module_tags" and prepare the
# tag blocks for each sub-module
locals {
  base_module_tags = {
    deployedBy = "AzureNoOpsTF"
  }
  hub_resources_tags = merge(local.base_module_tags,
    local.default_tags,
  )
  operations_resources_tags = merge(local.base_module_tags,
    local.default_tags,
  )
  sharedservices_resources_tags = merge(local.base_module_tags,
    local.default_tags,
  )
}
