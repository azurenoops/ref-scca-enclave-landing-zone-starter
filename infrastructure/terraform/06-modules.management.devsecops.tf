# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

################################
### Hub/Spoke Configuations  ###
################################

module "mod_devsecops" {
  source     = "./modules/06-devsecops"
  depends_on = [module.mod_landing_zone]

  # Global Configuration
  location           = var.default_location
  deploy_environment = var.deploy_environment
  org_name           = var.org_name
  environment        = var.environment

  # DevSecOps Network Configuration
  resource_group_name  = module.mod_landing_zone.devsecops_resource_group_name
  virtual_network_name = module.mod_landing_zone.devsecops_virtual_network_name
  subnet_name          = module.mod_landing_zone.devsecops_default_subnet_names["vm"].name # add to the vm subnet

  # Key Vault Configuration
  enabled_for_deployment            = var.enabled_for_deployment
  enabled_for_disk_encryption       = var.enabled_for_disk_encryption
  enabled_for_template_deployment   = var.enabled_for_template_deployment
  admin_group_name                  = var.admin_group_name
  enable_key_vault_private_endpoint = var.enable_key_vault_private_endpoint
  existing_private_subnet_name      = module.mod_landing_zone.devsecops_default_subnet_names["private-endpoints"].name # add to the pe subnet

  # Bastion VM Configuration 
  # This module supports multiple Pre-Defined windows and Windows Distributions.
  # Check the module README.md file for more pre-defined images for Ubuntu, Centos, RedHat.  
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
  existing_network_security_group_name = module.mod_landing_zone.devsecops_default_nsg_names["vm"].name # TODO: Change this to vm subnet nsg
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
  log_analytics_resource_id = module.mod_landing_zone.ops_logging_log_analytics_resource_id

  # Deploy log analytics agents on a virtual machine. 
  # Customer id and primary shared key for Log Analytics workspace are required.
  deploy_log_analytics_agent       = var.deploy_log_analytics_agent
  log_analytics_workspace_id       = module.mod_landing_zone.ops_logging_log_analytics_workspace_id
  log_analytics_primary_shared_key = module.mod_landing_zone.ops_logging_log_analytics_primary_shared_key
}
