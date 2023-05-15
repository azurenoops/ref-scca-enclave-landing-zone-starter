# hub_network module outputs
output "hub_resource_group_name" {
  description = "The name of the hub resource group"
  value       = module.mod_hub_network.resource_group_name
}

output "hub_virtual_network_name" {
  description = "The name of the hub virtual network"
  value       = module.mod_hub_network.virtual_network_name
}

output "hub_virtual_network_id" {
  description = "The id of the hub virtual network"
  value       = module.mod_hub_network.virtual_network_id
}

output "hub_virtual_network_address_space" {
  description = "The id of the hub virtual network"
  value       = module.mod_hub_network.virtual_network_address_space
}

output "hub_default_subnet_ids" {
  description = "The id of the default subnet"
  value       = module.mod_hub_network.subnet_ids
}

output "hub_default_subnet_names" {
  description = "The name of the default subnet"
  value       = module.mod_hub_network.subnet_names
}

# hub_network firewall module outputs
output "firewall_id" {
  description = "The ID of the Azure Firewall"
  value       = module.mod_hub_network.firewall_id
}

output "firewall_public_ip" {
  description = "the public ip of firewall."
  value       = module.mod_hub_network.firewall_client_public_ip
}

output "firewall_private_ip" {
  description = "The private ip of firewall."
  value       = module.mod_hub_network.firewall_private_ip
}

# hub_network module outputs
output "hub_ddos_protection_plan_id" {
  description = "The name of the hub resource group"
  value       = module.mod_hub_network.ddos_protection_plan_id
}

output "hub_private_dns_zone_ids" {
  description = "The name of the hub resource group"
  value       = module.mod_hub_network.private_dns_zone_ids
}

# ops_network module outputs
output "operations_resource_group_name" {
  description = "The name of the operations resource group"
  value       = module.mod_ops_network.resource_group_name
}

output "operations_virtual_network_name" {
  description = "The name of the spoke virtual network"
  value       = module.mod_ops_network.virtual_network_name
}

output "operations_default_subnet_ids" {
  description = "The ids of the default subnet"
  value       = module.mod_ops_network.subnet_ids
}

# operational logging module outputs

output "ops_logging_resource_id" {
  description = "Resource ID of Managment Logging Log Analytics Workspace"
  value       = module.mod_hub_network.managmement_logging_log_analytics_id
}

output "ops_logging_log_analytics_name" {
  description = "Name of Managment Logging Log Analytics Workspace"
  value       = module.mod_hub_network.managmement_logging_log_analytics_name
}

output "ops_logging_storage_account_id" {
  description = "Name of Managment Logging Storage Account Id"
  value       = module.mod_hub_network.managmement_logging_storage_account_id
}

# svcs_network module outputs
output "svcs_resource_group_name" {
  description = "The name of the shared services resource group"
  value       = module.mod_svcs_network.resource_group_name
}

output "svcs_virtual_network_name" {
  description = "The name of the spoke virtual network"
  value       = module.mod_svcs_network.virtual_network_name
}

output "svcs_default_subnet_ids" {
  description = "The ids of the default subnet"
  value       = module.mod_svcs_network.subnet_ids
}
