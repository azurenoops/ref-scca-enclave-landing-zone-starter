# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

output "role_definition_ids" {
  value       = var.deploy_custom_roles == true ? module.mod_custom_roles.0.role_definition_ids : null
  description = "List of Role Definition IDs."
}

output "role_definition_resource_ids" {
  value       = var.deploy_custom_roles == true ? module.mod_custom_roles.0.role_definition_resource_ids : null
  description = "List of Azure Resource Manager IDs for the resources."
}
