# hub_network module outputs
output "hub_resource_group_name" {
  description = "The name of the hub resource group"
  value       = module.mod_hub_network.hub_resource_group_name
}

output "hub_virtual_network_name" {
  description = "The name of the hub virtual network"
  value       = module.mod_hub_network.hub_virtual_network_name
}

output "hub_virtual_network_id" {
  description = "The id of the hub virtual network"
  value       = module.mod_hub_network.hub_virtual_network_id
}

output "hub_default_subnet_id" {
  description = "The id of the default subnet"
  value       = module.mod_hub_network.hub_default_subnet_id
}

output "hub_default_subnet_name" {
  description = "The name of the default subnet"
  value       = module.mod_hub_network.hub_default_subnet_name
}

# hub_network firewall module outputs
output "firewall_id" {
  description = "The ID of the Azure Firewall"
  value       = module.mod_hub_network.firewall_id
}

output "firewall_public_ip" {
  description = "the public ip of firewall."
  value       = module.mod_hub_network.firewall_public_ip
}

output "firewall_private_ip" {
  description = "The private ip of firewall."
  value       = module.mod_hub_network.firewall_private_ip
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

output "operations_default_subnet_id" {
  description = "The id of the default subnet"
  value       = module.mod_ops_network.default_subnet_id
}

output "operations_default_subnet_name" {
  description = "The id of the default subnet"
  value       = module.mod_ops_network.default_subnet_name
}

# operational logging module outputs

output "ops_logging_workspace_id" {
  description = "Resource ID of Log Analytics Workspace"
  value = module.mod_operational_logging.laws_resource_id
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

output "svcs_default_subnet_id" {
  description = "The id of the default subnet"
  value       = module.mod_svcs_network.default_subnet_id
}

output "svcs_default_subnet_name" {
  description = "The id of the default subnet"
  value       = module.mod_svcs_network.default_subnet_name
}
