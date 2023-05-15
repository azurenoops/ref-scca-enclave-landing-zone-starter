# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy an Azure SQL for a Mission Enclave
DESCRIPTION: The following components will be options in this deployment
             * Azure SQL
             * Azure SQL Server
             * Azure SQL Database
AUTHOR/S: jspinella
*/

#################################
### Azure SQL Configuations   ###
#################################

module "mod_azsql" {
  source  = "azurenoops/overlays-azsql/azurerm"
  version = ">= 0.2.0"

  existing_resource_group_name = var.resource_group_name
  location                     = var.location
  deploy_environment           = var.deploy_environment
  org_name                     = var.org_name
  environment                  = var.environment
  workload_name                = var.workload_name

  # The admin of the SQL Server. If you do not provide a password,
  # the module will generate a password for you.
  # The password must be at least 8 characters long and contain
  # characters from three of the following categories: English uppercase letters,
  # English lowercase letters, numbers (0-9), and non-alphanumeric characters (!, $, #, %, etc.).
  administrator_login    = "adminsqltest"
  
  # SQL server extended auditing policy defaults to `true`. 
  # To turn off set enable_sql_server_extended_auditing_policy to `false`  
  # DB extended auditing policy defaults to `false`. 
  # to tun on set the variable `enable_database_extended_auditing_policy` to `true` 
  # To enable Azure Defender for database set `enable_threat_detection_policy` to true 
  enable_threat_detection_policy = true
  log_retention_days             = 30

  # To create a database users set `create_databases_users` to `true`
  create_databases_users = true

  # Firewall Rules to allow azure and external clients and specific Ip address/ranges. 
  enable_firewall_rules = true
  firewall_rules = [
    {
      name             = "access-to-azure"
      start_ip_address = "0.0.0.0"
      end_ip_address   = "0.0.0.0"
    },
    {
      name             = "desktop-ip"
      start_ip_address = "123.201.36.94"
      end_ip_address   = "123.201.36.94"
    }
  ]

  # Create a Elastic Pool. 
  # To create a database in the elastic pool set `enable_elastic_pool` to `true`
  enable_elastic_pool = false

  # schedule scan notifications to the subscription administrators
  # Manage Vulnerability Assessment set `enable_sql_vulnerability_assessment` to `true`
  enable_sql_vulnerability_assessment = false
  email_addresses_for_alerts      = ["user@example.com", "firstname.lastname@example.com"]

  # Sql failover group creation. required secondary locaiton input. 
  enable_failover_group         = true
  secondary_sql_server_location = "northeurope"

  # Create a database.
  databases = [
    {
      name        = "db1"
      max_size_gb = 5
    },
    {
      name        = "db2"
      max_size_gb = 5
    }
  ]

  # Creating Private Endpoint requires, VNet name and address prefix to create a subnet
  # By default this will create a `privatelink.database.windows.net` DNS zone. 
  # To use existing private DNS zone specify `existing_private_dns_zone` with valid zone name
  enable_private_endpoint        = true
  virtual_network_name           = azurerm_virtual_network.vnet.name  
  private_subnet_address_prefix  = ["10.0.100.0/24"]

  # AD administrator for an Azure SQL server
  # Allows you to set a user or group as the AD administrator for an Azure SQL server
  ad_admin_login_name = "firstname.lastname@example.com"

  # (Optional) To enable Azure Monitoring for Azure SQL database including audit logs
  # Log Analytic workspace resource id required
  # (Optional) Specify `storage_account_id` to save monitoring logs to storage. 
  enable_log_monitoring      = true
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.example.id
  
  # Tags
  add_tags = var.default_tags # Tags to be applied to all resources
}