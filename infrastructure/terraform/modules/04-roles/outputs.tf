# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

output "role_definition_ids" {
  value       = module.mod_custom_roles.0.role_definition_ids
  description = "List of Role Definition IDs."
}

output "role_definition_resource_ids" {
  value       = module.mod_custom_roles.0.role_definition_resource_ids
  description = "List of Azure Resource Manager IDs for the resources."
}
