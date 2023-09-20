
# management_groups module outputs
output "management_groups" {
  value = var.enable_management_groups ? module.mod_management_group[0].management_groups : null
  sensitive = true
}

# management_groups budgets module outputs
/* output "management_groups_budgets" {
  value = var.enable_management_groups ? module.mod_management_group[0].management_groups_budgets : null
  sensitive = true
} */

# roles module outputs
/* output "role_definition_ids" {
  value       = module.mod_custom_roles.role_definition_ids
  description = "List of Role Definition IDs."
}

output "role_definition_resource_ids" {
  value       = module.mod_custom_roles.role_definition_resource_ids
  description = "List of Azure Resource Manager IDs for the resources."
} */

# landing zone module outputs
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
  description = "The names of the default subnets"
  value       = module.mod_hub_network.subnet_names
}

output "hub_storage_account_id" {
  description = "The ids of the default subnets"
  value       = module.mod_hub_network.storage_account_id
}

output "hub_default_nsg_names" {
  description = "The names of each hub network security groups"
  value       = module.mod_hub_network.network_security_group_names
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

# id_network module outputs
output "identity_resource_group_name" {
  description = "The name of the Identity resource group"
  value       = module.mod_id_network.resource_group_name
}

output "identity_virtual_network_name" {
  description = "The name of the Identity spoke virtual network"
  value       = module.mod_id_network.virtual_network_name
}

output "identity_default_subnet_ids" {
  description = "The ids of the Identity default subnets"
  value       = module.mod_id_network.subnet_ids
}

output "identity_default_subnet_names" {
  description = "The names of the Identity default subnets"
  value       = module.mod_id_network.subnet_names
}

output "identity_default_nsg_names" {
  description = "The names of each Identity network security groups"
  value       = module.mod_id_network.network_security_group_names
}

# ops_network module outputs
output "operations_resource_group_name" {
  description = "The name of the Operations resource group"
  value       = module.mod_ops_network.resource_group_name
}

output "operations_virtual_network_name" {
  description = "The name of the Operations spoke virtual network"
  value       = module.mod_ops_network.virtual_network_name
}

output "operations_default_subnet_ids" {
  description = "The ids of the Operations default subnets"
  value       = module.mod_ops_network.subnet_ids
}

output "operations_default_subnet_names" {
  description = "The names of the Operations default subnets"
  value       = module.mod_ops_network.subnet_names
}

output "operations_default_nsg_names" {
  description = "The names of each Operations network security groups"
  value       = module.mod_ops_network.network_security_group_names
}

# operational logging module outputs

output "ops_logging_log_analytics_resource_id" {
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

output "ops_logging_log_analytics_workspace_id" {
  description = "Resource ID of Managment Logging Log Analytics Workspace"
  value       = module.mod_hub_network.managmement_logging_log_analytics_workspace_id
}

output "ops_logging_log_analytics_primary_shared_key" {
  description = "Resource ID of Managment Logging Log Analytics Workspace"
  value       = module.mod_hub_network.managmement_logging_log_analytics_primary_shared_key
  sensitive = true
}

# devsecops_network module outputs
output "devsecops_resource_group_name" {
  description = "The name of the DevSecOps resource group"
  value       = module.mod_devsecops_network.resource_group_name
}

output "devsecops_virtual_network_name" {
  description = "The name of the DevSecOps spoke virtual network"
  value       = module.mod_devsecops_network.virtual_network_name
}

output "devsecops_default_subnet_ids" {
  description = "The ids of the DevSecOps default subnets"
  value       = module.mod_devsecops_network.subnet_ids
}

output "devsecops_default_subnet_names" {
  description = "The names of the DevSecOps default subnets"
  value       = module.mod_devsecops_network.subnet_names
}

output "devsecops_default_nsg_names" {
  description = "The names of each DevSecOps network security groups"
  value       = module.mod_devsecops_network.network_security_group_names
}