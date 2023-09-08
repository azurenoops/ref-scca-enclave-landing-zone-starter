# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

###############################
## Key Vault Configuration  ###
###############################
module "mod_shared_keyvault" {
  depends_on = [ module.mod_devsecops_network ]
  source  = "azurenoops/overlays-key-vault/azurerm"
  version = "~> 2.0"

  count = var.enable_devsecops ? 1 : 0

  # By default, this module will create a resource group and 
  # provide a name for an existing resource group. If you wish 
  # to use an existing resource group, change the option 
  # to "create_key_vault_resource_group = false."   
  existing_resource_group_name = module.mod_devsecops_network.resource_group_name
  location                     = var.default_location
  deploy_environment           = var.deploy_environment
  org_name                     = var.org_name
  environment                  = var.environment
  workload_name                = "shared-keys"

  # This is to enable the features of the key vault
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment

  # This is to enable public access to the key vault, since we are using a private network and endpoint, we will disable it
  public_network_access_enabled = false

  # This is to enable the network access to the key vault
  network_acls = {
    bypass         = "AzureServices"
    default_action = "Deny"
  }

  # Current user should be here to be able to create keys and secrets
  rbac_authorization_enabled = var.rbac_authorization_enabled
  /* admin_objects_ids = [
    data.azuread_group.admin_group.id
  ] */

  # Creating Private Endpoint requires, VNet name to create a Private Endpoint
  # By default this will create a `privatelink.vaultcore.azure.net` DNS zone. if created in commercial cloud
  # To use existing subnet, specify `existing_subnet_id` with valid subnet id. 
  # To use existing private DNS zone specify `existing_private_dns_zone` with valid zone name
  # Private endpoints doesn't work If not using `existing_subnet_id` to create key vault inside a specified VNet.
  enable_private_endpoint      = var.enable_key_vault_private_endpoint
  virtual_network_name         = module.mod_devsecops_network.virtual_network_name
  existing_private_subnet_name = module.mod_devsecops_network.subnet_names["private-endpoints"].name
  existing_private_dns_zone    = "privatelink.vaultcore.azure.net"

  # This is to enable resource locks for the key vault. 
  enable_resource_locks = var.enable_resource_locks

  # Tags for Azure Resources
  add_tags = local.devsecops_resources_tags
}

#####################################
## Bastion Jumpbox Configuration  ###
#####################################

module "mod_bastion_virtual_machine" {
  depends_on = [ module.mod_devsecops_network ]
  source  = "azurenoops/overlays-virtual-machine/azurerm"
  version = "~> 2.0"

  count = var.enable_devsecops ? 1 : 0
  
  # Resource Group, location, VNet and Subnet details
  existing_resource_group_name = module.mod_devsecops_network.resource_group_name
  location                     = var.default_location
  deploy_environment           = var.deploy_environment
  org_name                     = var.org_name
  workload_name                = "jmp"

  # Shared Services Network Configuration
  existing_virtual_network_name = module.mod_devsecops_network.virtual_network_name
  existing_subnet_name          = module.mod_devsecops_network.subnet_names["vm"].name

  # This module support multiple Pre-Defined windows and Windows Distributions.
  # Check the README.md file for more pre-defined images for Ubuntu, Centos, RedHat.
  # Please make sure to use gen2 images supported VM sizes if you use gen2 distributions
  # Specify `disable_password_authentication = false` to create random admin password
  # Specify a valid password with `admin_password` argument to use your own password .  
  os_type                   = "windows"
  windows_distribution_name = var.windows_distribution_name
  virtual_machine_size      = var.virtual_machine_size
  admin_username            = var.vm_admin_username
  admin_password            = var.vm_admin_password
  instances_count           = var.instances_count # Number of VM's to be deployed

  # The proximity placement group, Availability Set, and assigning a public IP address to VMs are all optional.
  # If you don't wish to utilize these arguments, delete them from the module. 
  enable_proximity_placement_group = var.enable_proximity_placement_group
  enable_vm_availability_set       = var.enable_vm_availability_set
  enable_public_ip_address         = var.enable_public_ip_address

  # Network Seurity group port definitions for each Virtual Machine 
  # NSG association for all network interfaces to be added automatically.
  # Using 'existing_network_security_group_name' is supplied then the module will use the existing NSG.
  existing_network_security_group_name = module.mod_devsecops_network.network_security_group_names["vm"].name
  nsg_inbound_rules                    = var.nsg_inbound_rules

  # Boot diagnostics are used to troubleshoot virtual machines by default. 
  # To use a custom storage account, supply a valid name for'storage_account_name'. 
  # Passing a 'null' value will use a Managed Storage Account to store Boot Diagnostics.
  enable_boot_diagnostics = var.enable_boot_diagnostics

  # Attach a managed data disk to a Windows/windows virtual machine. 
  # Storage account types include: #'Standard_LRS', #'StandardSSD_ZRS', #'Premium_LRS', #'Premium_ZRS', #'StandardSSD_LRS', #'UltraSSD_LRS' (UltraSSD_LRS is only accessible in regions that support availability zones).
  # Create a new data drive - connect to the VM and execute diskmanagemnet or fdisk.
  data_disks = var.data_disks

  # (Optional) To activate Azure Monitoring and install log analytics agents 
  # (Optional) To save monitoring logs to storage, specify'storage_account_name'.    
  log_analytics_workspace_id = module.mod_hub_network.managmement_logging_log_analytics_id

  # Deploy log analytics agents on a virtual machine. 
  # Customer id and primary shared key for Log Analytics workspace are required.
  deploy_log_analytics_agent                 = var.deploy_log_analytics_agent
  log_analytics_customer_id                  = module.mod_hub_network.managmement_logging_log_analytics_workspace_id
  log_analytics_workspace_primary_shared_key = module.mod_hub_network.managmement_logging_log_analytics_primary_shared_key

  # Adding additional TAG's to your Azure resources
  add_tags = local.devsecops_resources_tags
}
