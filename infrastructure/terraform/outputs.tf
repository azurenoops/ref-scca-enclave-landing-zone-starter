
# management_groups module outputs
output "management_groups" {
  value = module.mod_management_groups.management_groups
  sensitive = true
}

# management_groups budgets module outputs

# landing_zone module outputs
output "hub_resource_group_name" {
  description = "The name of the hub resource group"
  value       = module.landing_zone.hub_resource_group_name
}

output "hub_virtual_network_name" {
  description = "The name of the hub virtual network"
  value       = module.landing_zone.hub_virtual_network_name
}

output "hub_virtual_network_id" {
  description = "The id of the hub virtual network"
  value       = module.landing_zone.hub_virtual_network_id
}

output "hub_default_subnet_ids" {
  description = "The id of the default subnet"
  value       = module.landing_zone.hub_default_subnet_ids
}

output "hub_default_subnet_names" {
  description = "The name of the default subnet"
  value       = module.landing_zone.hub_default_subnet_names
}

# landing_zone firewall module outputs
output "firewall_id" {
  description = "The ID of the Azure Firewall"
  value       = module.landing_zone.firewall_id
}

output "firewall_public_ip" {
  description = "the public ip of firewall."
  value       = module.landing_zone.firewall_public_ip
}

output "firewall_private_ip" {
  description = "The private ip of firewall."
  value       = module.landing_zone.firewall_private_ip
}

# ops_network module outputs
output "operations_resource_group_name" {
  description = "The name of the operations resource group"
  value       = module.landing_zone.operations_resource_group_name
}

output "operations_virtual_network_name" {
  description = "The name of the spoke virtual network"
  value       = module.landing_zone.operations_virtual_network_name
}

output "operations_default_subnet_ids" {
  description = "The id of the default subnet"
  value       = module.landing_zone.operations_default_subnet_ids
}

# operational logging module outputs

output "ops_logging_resource_id" {
  description = "Resource ID of Log Analytics Workspace"
  value = module.landing_zone.ops_logging_resource_id
}

output "ops_logging_log_analytics_name" {
  description = "Resource ID of Log Analytics Workspace"
  value = module.landing_zone.ops_logging_log_analytics_name
}

output "ops_logging_storage_account_id" {
  description = "Resource ID of Log Analytics Storage Account Id"
  value = module.landing_zone.ops_logging_storage_account_id
}

# svcs_network module outputs
output "svcs_resource_group_name" {
  description = "The name of the shared services resource group"
  value       = module.landing_zone.svcs_resource_group_name
}

output "svcs_virtual_network_name" {
  description = "The name of the spoke virtual network"
  value       = module.landing_zone.svcs_virtual_network_name
}

output "svcs_default_subnet_ids" {
  description = "The id of the default subnet"
  value       = module.landing_zone.svcs_default_subnet_ids
}
