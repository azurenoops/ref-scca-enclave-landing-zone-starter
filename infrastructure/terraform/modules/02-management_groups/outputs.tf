# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

output "management_groups" {
  value = module.mod_management_group.0.management_groups
}
