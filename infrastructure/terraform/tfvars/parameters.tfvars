# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

###########################
## Global Configuration  ##
###########################

# The prefixes to use for all resources in this deployment
org_name           = "anoa"         # This Prefix will be used on most deployed resources.  10 Characters max.
deploy_environment = "dev"          # dev | test | prod
environment        = "usgovernment" # public | usgovernment

# The default region to deploy to
default_location = "usgovvirginia"

# Enable locks on resources
enable_resource_locks = false # true | false

# Enable NSG Flow Logs
# By default, this will enable flow logs traffic analytics for all subnets.
enable_traffic_analytics = true

########################################
# 02 Management Groups Configuration  ##
########################################

enable_management_groups           = true   # enable management groups for this subscription
root_management_group_id           = "anoa" # the root management group id for this subscription
root_management_group_display_name = "anoa" # the root management group display name for this subscription

# Management groups to create
# The management group structure is created in the locals.tf file

################################################
# 03 Management Groups Budgets Configuration  ##
################################################

# Budgets for management groups
enable_management_groups_budgets = false                  # enable budgets for management groups
budget_contact_emails            = ["anoa@microsoft.com"] # email addresses to send alerts to for this subscription
budget_amount                    = "5000"
budget_start_date                = "2023-09-01T00:00:00Z" # RFC3339 format: YYYY-MM-DDTHH:MM:SSZ
budget_end_date                  = "2023-12-31T00:00:00Z" # RFC3339 format: YYYY-MM-DDTHH:MM:SSZ

################################################
# 04 Management Groups Roles Configuration  ##
################################################

deploy_custom_roles = true # true | false

# Management Groups Roles to create
# The management group roles structure is created in the locals.tf file

################################
# Landing Zone Configuration  ##
################################

#######################################
# 05 Management Hub Virtual Network  ##
#######################################

# (Required)  Hub Virtual Network Parameters   
# Provide valid VNet Address space and specify valid domain name for Private DNS Zone.  
hub_vnet_address_space              = ["10.8.4.0/23"]   # (Required)  Hub Virtual Network Parameters  
fw_client_snet_address_prefixes     = ["10.8.4.64/26"]  # (Required)  Hub Firewall Subnet Parameters  
ampls_subnet_address_prefixes       = ["10.8.5.160/27"] # (Required)  AMPLS Subnet Parameter
fw_management_snet_address_prefixes = ["10.8.4.128/26"] # (Optional)  Hub Firewall Management Subnet Parameters. If not provided, force_tunneling is not needed. 

# (Required) DDOS Protection Plan
# By default, Azure NoOps will create DDOS Protection Plan in Hub VNet.
# If you do not want to create DDOS Protection Plan,
# set create_ddos_plan to false.
create_ddos_plan = true

# (Required) Hub Subnets 
# Default Subnets, Service Endpoints
# This is the default subnet with required configuration, check README.md for more details
# First address ranges from VNet Address space reserved for Firewall Subnets. 
# First three address ranges from VNet Address space reserved for Gateway, AMPLS And Firewall Subnets. 
# ex.: For 10.8.4.0/23 address space, usable address range start from "10.8.4.224/27" for all subnets.
# default subnet name will be set as per Azure NoOps naming convention by defaut.
# Multiple Subnets, Service delegation, Service Endpoints, Network security groups
# These are default subnets with required configuration, check README.md for more details
# NSG association to be added automatically for all subnets listed here.
# subnet name will be set as per Azure naming convention by defaut. expected value here is: <App or project name>
hub_subnets = {
  default = {
    name                                       = "hub-core"
    address_prefixes                           = ["10.8.4.224/27"]
    service_endpoints                          = ["Microsoft.Storage"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true
  },
}

########################################
# 05a Management OperationL Logging  ###
########################################

# Log Analytics Workspace Settings
log_analytics_workspace_sku          = "PerGB2018"
log_analytics_logs_retention_in_days = 30

# Azure Monitor Settings
# All solutions are enabled (true) by default
enable_sentinel              = true
enable_azure_activity_log    = true
enable_vm_insights           = true
enable_azure_security_center = true
enable_container_insights    = true
enable_key_vault_analytics   = true
enable_service_map           = true

#################################
# 05b Management Hub Firewall ###
#################################

# Firewall Settings
# By default, Azure NoOps will create Azure Firewall in Hub VNet. 
# If you do not want to create Azure Firewall, 
# set enable_firewall to false. This will allow different firewall products to be used (Example: F5).  
enable_firewall = true

# By default, forced tunneling is enabled for Azure Firewall.
# If you do not want to enable forced tunneling, 
# set enable_forced_tunneling to false.
enable_forced_tunneling = true


# (Optional) To enable the availability zones for firewall. 
# Availability Zones can only be configured during deployment 
# You can't modify an existing firewall to include Availability Zones
firewall_zones = []

# # (Optional) specify the Network rules for Azure Firewall l
# This is default values, do not need this if keeping default values
firewall_network_rules = [
  {
    name     = "AllowAzureCloud"
    priority = "100"
    action   = "Allow"
    rules = [
      {
        name                  = "AzureCloud"
        protocols             = ["Any"]
        source_addresses      = ["*"]
        destination_addresses = ["AzureCloud"]
        destination_ports     = ["*"]
      }
    ]
  },
  {
    name     = "AllowTrafficBetweenSpokes"
    priority = "200"
    action   = "Allow"
    rules = [
      {
        name                  = "AllSpokeTraffic"
        protocols             = ["Any"]
        source_addresses      = ["10.96.0.0/19"]
        destination_addresses = ["*"]
        destination_ports     = ["*"]
      }
    ]
  }
]

# (Optional) specify the application rules for Azure Firewall
# This is default values, do not need this if keeping default values
firewall_application_rules = [
  {
    name     = "AzureAuth"
    priority = "110"
    action   = "Allow"
    rules = [
      {
        name              = "msftauth"
        source_addresses  = ["*"]
        destination_fqdns = ["aadcdn.msftauth.net", "aadcdn.msauth.net"]
        protocols = {
          type = "Https"
          port = 443
        }
      }
    ]
  }
]

#######################################
# 05c Bastion/Hub Private DNS Zones ###
#######################################

# Private DNS Zone Settings
# By default, Azure NoOps will create Private DNS Zones for Logging in Hub VNet.
# If you do want to create addtional Private DNS Zones, 
# add in the list of private_dns_zones to be created.
# else, remove the private_dns_zones argument.
hub_private_dns_zones = []

# By default, this module will create a bastion host, 
# and set the argument to `enable_bastion_host = false`, to disable the bastion host.
enable_bastion_host                 = true
azure_bastion_host_sku              = "Standard"
azure_bastion_subnet_address_prefix = ["10.8.4.192/27"]

####################################################
# 5d Identity Management Spoke Virtual Network   ###
####################################################

# Enable Identity Management Spoke Virtual Network
# If you do not want to create Identity Management Spoke Virtual Network,
# remove this section from the configuration file.

# Identity Virtual Network Parameters
id_name               = "id"
id_vnet_address_space = ["10.8.9.0/24"]
id_subnets = {
  default = {
    name                                       = "id"
    address_prefixes                           = ["10.8.9.224/27"]
    service_endpoints                          = ["Microsoft.Storage"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true
    nsg_subnet_rules = [
      {
        name                       = "Allow-Traffic-From-Spokes",
        description                = "Allow traffic from spokes",
        priority                   = 200,
        direction                  = "Inbound",
        access                     = "Allow",
        protocol                   = "*",
        source_port_range          = "*",
        destination_port_ranges    = ["22", "80", "443", "3389"],
        source_address_prefixes    = ["10.8.6.0/24", "10.8.7.0/24", "10.8.8.0/24"]
        destination_address_prefix = "10.8.9.0/24"
      }
    ]
  }
}

# Private DNS Zones
# Add in the list of private_dns_zones to be created.
id_private_dns_zones = []

# Enable forced tunneling on the route table
enable_forced_tunneling_on_id_route_table = true


####################################################
# 5d Operations Management Spoke Virtual Network ###
####################################################

# Operations Virtual Network Parameters
ops_name               = "ops"
ops_vnet_address_space = ["10.8.6.0/24"]
ops_subnets = {
  default = {
    name                                       = "ops"
    address_prefixes                           = ["10.8.6.224/27"]
    service_endpoints                          = ["Microsoft.Storage"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true
    nsg_subnet_rules = [
      {
        name                       = "Allow-Traffic-From-Spokes",
        description                = "Allow traffic from spokes",
        priority                   = 200,
        direction                  = "Inbound",
        access                     = "Allow",
        protocol                   = "*",
        source_port_range          = "*",
        destination_port_ranges    = ["22", "80", "443", "3389"],
        source_address_prefixes    = ["10.8.9.0/24", "10.8.7.0/24", "10.8.8.0/24"]
        destination_address_prefix = "10.8.6.0/24"
      }
    ]
  }
}

# Private DNS Zones
# Add in the list of private_dns_zones to be created.
ops_private_dns_zones = []

# Enable forced tunneling on the route table
enable_forced_tunneling_on_ops_route_table = true

##########################################################
# 05e DevSecOps Management Spoke Virtual Network       ###
##########################################################

# DevSecOps Virtual Network Parameters
devsecops_name               = "devsecops"
devsecops_vnet_address_space = ["10.8.7.0/24"]
devsecops_subnets = {
  default = {
    name                                       = "devsecops"
    address_prefixes                           = ["10.8.7.224/27"]
    service_endpoints                          = ["Microsoft.Storage", "Microsoft.KeyVault"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true
    nsg_subnet_rules = [
      {
        name                       = "Allow-Traffic-From-Spokes",
        description                = "Allow traffic from spokes",
        priority                   = 200,
        direction                  = "Inbound",
        access                     = "Allow",
        protocol                   = "*",
        source_port_range          = "*",
        destination_port_ranges    = ["22", "80", "443", "3389"],
        source_address_prefixes    = ["10.8.9.0/24", "10.8.6.0/24", "10.8.8.0/24"]
        destination_address_prefix = "10.8.7.0/24"
      }
    ]
  },
  private-endpoints = {
    name                                       = "pe"
    address_prefixes                           = ["10.8.7.96/27"]
    service_endpoints                          = ["Microsoft.Storage", "Microsoft.KeyVault"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true
  },
  vm = {
    name                                       = "vm"
    address_prefixes                           = ["10.8.7.64/27"]
    service_endpoints                          = ["Microsoft.Storage", "Microsoft.KeyVault"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true
  }
}

# Private DNS Zones
# Add in the list of private_dns_zones to be created.
devsecops_private_dns_zones = ["privatelink.vaultcore.azure.net"]

# Enable forced tunneling on the route table
enable_forced_tunneling_on_devsecops_route_table = true

#############################
## Peering Configuration  ###
#############################

# Peering Configuration
# By default, Azure NoOps will create peering between hub and spoke vnets.
use_remote_spoke_gateway = false

################################
# 06 DevSecOps Configuration  ##
################################

# DevSecOps Configuration
# Turn on to enable DevSecOps resources
enable_devsecops_resources = true

# Azure Key Vault
enabled_for_deployment            = true
enabled_for_disk_encryption       = true
enabled_for_template_deployment   = true
rbac_authorization_enabled        = false
enable_key_vault_private_endpoint = true
admin_group_name                  = "61bd9160-00b0-4019-8f34-d2e105b17b73"

# Bastion VM Configuration
windows_distribution_name = "windows2019dc"
virtual_machine_size      = "Standard_B1s"

# Check the README.md file for more pre-defined images for Windows, Ubuntu, Centos, RedHat.
# Please make sure to use gen2 images supported VM sizes if you use gen2 distributions
# Specify a valid password with `admin_password` argument to use your own password .  
vm_admin_username = "azureuser"
instances_count   = 1

# Network Seurity group port definitions for each Virtual Machine 
# NSG association for all network interfaces to be added automatically.
nsg_inbound_rules = [
  {
    name                   = "ssh"
    destination_port_range = "22"
    source_address_prefix  = "*"
  },
  {
    name                   = "rdp"
    destination_port_range = "3386"
    source_address_prefix  = "*"
  },
]

# Attach a managed data disk to a Windows/windows virtual machine. 
# Storage account types include: #'Standard_LRS', #'StandardSSD_ZRS', #'Premium_LRS', #'Premium_ZRS', #'StandardSSD_LRS', #'UltraSSD_LRS' (UltraSSD_LRS is only accessible in regions that support availability zones).
# Create a new data drive - connect to the VM and execute diskmanagemnet or fdisk.
data_disks = [
  {
    name                 = "disk1"
    disk_size_gb         = 100
    storage_account_type = "StandardSSD_LRS"
  },
  {
    name                 = "disk2"
    disk_size_gb         = 200
    storage_account_type = "Standard_LRS"
  }
]

# Deploy log analytics agents on a virtual machine. 
# Customer id and primary shared key for Log Analytics workspace are required.
deploy_log_analytics_agent = true

#################################
# 07 Sentinel Configuration   ###
#################################

# Sentinel Configuration
enable_sentinel_rule_alerts = false

# Sentinel Rule Alerts
sentinel_rule_alerts = {
  "AAD_No_Password_Expiry" = {
    query_frequency = "P1D"
    query_period    = "P1D"
    severity        = "Low"

    query = <<EOF
              union isfuzzy=true 
              (
              SecurityEvent
              | where EventID == 4738
              // 2089 value indicates the Don't Expire Password value has been set
              | where UserAccountControl has "%%2089" 
              | extend Value_2089 = iff(UserAccountControl has "%%2089","'Don't Expire Password' - Enabled", "Not Changed")
              // 2050 indicates that the Password Not Required value is NOT set, this often shows up at the same time as a 2089 and is the recommended value.  This value may not be in the event. 
              | extend Value_2050 = iff(UserAccountControl has "%%2050","'Password Not Required' - Disabled", "Not Changed")
              // If value %%2082 is present in the 4738 event, this indicates the account has been configured to logon WITHOUT a password. Generally you should only see this value when an account is created and only in Event 4720: Account Creation Event.  
              | extend Value_2082 = iff(UserAccountControl has "%%2082","'Password Not Required' - Enabled", "Not Changed")
              | project StartTime = TimeGenerated, EventID, Activity, Computer, TargetAccount, TargetSid, AccountType, UserAccountControl, Value_2089, Value_2050, Value_2082, SubjectAccount
              | extend timestamp = StartTime, AccountCustomEntity = TargetAccount, HostCustomEntity = Computer
              ),
              (
              WindowsEvent
              | where EventID == 4738 and EventData has '2089'
              // 2089 value indicates the Don't Expire Password value has been set
              | extend UserAccountControl = tostring(EventData.UserAccountControl)
              | where UserAccountControl has "%%2089" 
              | extend Value_2089 = iff(UserAccountControl has "%%2089","'Don't Expire Password' - Enabled", "Not Changed")
              // 2050 indicates that the Password Not Required value is NOT set, this often shows up at the same time as a 2089 and is the recommended value.  This value may not be in the event. 
              | extend Value_2050 = iff(UserAccountControl has "%%2050","'Password Not Required' - Disabled", "Not Changed")
              // If value %%2082 is present in the 4738 event, this indicates the account has been configured to logon WITHOUT a password. Generally you should only see this value when an account is created and only in Event 4720: Account Creation Event.  
              | extend Value_2082 = iff(UserAccountControl has "%%2082","'Password Not Required' - Enabled", "Not Changed")
              | extend Activity="4738 - A user account was changed."
              | extend TargetAccount = strcat(EventData.TargetDomainName,"\\", EventData.TargetUserName)
              | extend TargetSid = tostring(EventData.TargetSid)
              | extend SubjectAccount = strcat(EventData.SubjectDomainName,"\\", EventData.SubjectUserName)
              | extend SubjectUserSid = tostring(EventData.SubjectUserSid)
              | extend AccountType=case(SubjectAccount endswith "$" or SubjectUserSid in ("S-1-5-18", "S-1-5-19", "S-1-5-20"), "Machine", isempty(SubjectUserSid), "", "User")
              | project StartTime = TimeGenerated, EventID, Activity, Computer, TargetAccount, TargetSid, AccountType, UserAccountControl, Value_2089, Value_2050, Value_2082, SubjectAccount
              | extend timestamp = StartTime, AccountCustomEntity = TargetAccount, HostCustomEntity = Computer
              )
              EOF


    entity_mappings = [
      {
        entity_type = "Account"
        field_mappings = [{
          identifier  = "FullName"
          column_name = "AccountCustomEntity"
        }]
      },
      {
        entity_type = "Host"
        field_mappings = [{
          identifier  = "HostName"
          column_name = "HostCustomEntity"
        }]
      }

    ]

    tactics    = ["Persistence"]
    techniques = ["T1098"]

    display_name = "AAD_No_Password_Expiry"
    description  = <<EOT
Identifies whenever a user account has the setting "Password Never Expires" in the user account properties selected.
This is indicated in Security event 4738 in the EventData item labeled UserAccountControl with an included value of %%2089.
%%2089 resolves to "Don't Expire Password - Enabled".
EOT

    create_incident = true

    incident_configuration = {
      enabled                 = true
      lookback_duration       = "P1D"
      reopen_closed_incidents = true
      entity_matching_method  = "AllEntities"
      group_by_entities       = []
      group_by_alert_details  = ["Severity"]
    }

    suppression_duration = "P1D"
    suppression_enabled  = true
    event_grouping       = "SingleAlert"
  }, # End Alert

} # End Alert Rules


########################################### 
# 08 Azure Service Health Configuration  ##
###########################################

# Azure Service Health Configuration
enable_service_health_monitoring = true
action_group_short_name          = "anoaalerting"
