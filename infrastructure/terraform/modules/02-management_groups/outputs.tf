# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

output "management_groups" {
  value = length(module.mod_management_group) > 0 ? module.mod_management_group[0].management_groups : null
}
