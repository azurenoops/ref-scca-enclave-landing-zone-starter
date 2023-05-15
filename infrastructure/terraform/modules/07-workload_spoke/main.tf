# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy an Azure Budgets for a Partner Environment
DESCRIPTION: The following components will be options in this deployment
             * Budgets
AUTHOR/S: jspinella
*/

#############################
### Spoke Configuration   ###
#############################

// Resources for the Operations Spoke
module "mod_ops_network" {
  source    = "azurenoops/overlays-workload-spoke/azurerm"
  version   = ">= 2.0.0"

  # By default, this module will create a resource group, provide the name here
  # To use an existing resource group, specify the existing resource group name, 
  # and set the argument to `create_resource_group = false`. Location will be same as existing RG.
  create_resource_group = true
  location              = var.location
  deploy_environment    = var.deploy_environment
  org_name              = var.org_name
  environment           = var.environment
  workload_name         = var.ops_name
  
  # Collect Spoke Virtual Network Parameters
  # Spoke network details to create peering and other setup
  hub_virtual_network_id          = var.hub_virtual_network_id
  hub_firewall_private_ip_address = var.firewall_private_ip
  hub_storage_account_id          = var.hub_storage_account_id

  # (Required) To enable Azure Monitoring and flow logs
  # pick the values for log analytics workspace which created by Spoke module
  # Possible values range between 30 and 730
  log_analytics_workspace_id           = var.hub_managmement_logging_log_analytics_id
  log_analytics_customer_id            = var.hub_managmement_logging_storage_account_workspace_id
  log_analytics_logs_retention_in_days = 30

  # Provide valid VNet Address space for spoke virtual network.    
  virtual_network_address_space = var.ops_vnet_address_space # (Required)  Spoke Virtual Network Parameters

  # (Required) Specify if you are deploying the spoke VNet using the same hub Azure subscription
  is_spoke_deployed_to_same_hub_subscription = var.is_ops_spoke_deployed_to_same_hub_subscription

  # (Required) Multiple Subnets, Service delegation, Service Endpoints, Network security groups
  # These are default subnets with required configuration, check README.md for more details
  # Route_table and NSG association to be added automatically for all subnets listed here.
  # subnet name will be set as per Azure naming convention by defaut. expected value here is: <App or project name>
  spoke_subnets = var.ops_subnets

  # Enable Flow Logs
  # By default, this will enable flow logs for all subnets.
  enable_traffic_analytics = var.enable_traffic_analytics

  # By default, forced tunneling is enabled for the spoke.
  # If you do not want to enable forced tunneling on the spoke route table, 
  # set `enable_forced_tunneling = false`.
  enable_forced_tunneling_on_route_table = var.enable_forced_tunneling_on_ops_route_table

  # Private DNS Zone Settings
  # By default, Azure NoOps will create Private DNS Zones for Logging in Hub VNet.
  # If you do want to create addtional Private DNS Zones, 
  # add in the list of private_dns_zones to be created.
  # else, remove the private_dns_zones argument.
  private_dns_zones = var.ops_private_dns_zones

  # Peering
  # By default, Azure NoOps will create peering between Hub and Spoke.
  # Since is using a gateway, set the argument to `use_source_remote_spoke_gateway = true`, to enable gateway traffic.   
  use_source_remote_spoke_gateway = var.use_source_remote_spoke_gateway

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = var.enable_resource_locks

  # Tags
  add_tags = local.workload_resources_tags # Tags to be applied to all resources
}