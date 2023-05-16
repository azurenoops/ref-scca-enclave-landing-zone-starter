# Deploy Shared Services

The following will be created:

* Resource Groups for Spoke Networking
* Spoke Networks (Shared Services)

Review and if needed, comment out and modify the variables within the "06 Shared Services Configuration" section of the common variable definitons file [parameters.tfvars](./tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Sample:

```bash

######################################
# 06 Shared Services Configuration  ##
######################################

# Azure Key Vault
enabled_for_deployment            = true
enabled_for_disk_encryption       = true
enabled_for_template_deployment   = true
admin_group_name                  = "azure-platform-owners"
enable_key_vault_private_endpoint = true

# Bastion VM Configuration
windows_distribution_name = "windows2019dc"
virtual_machine_size      = "Standard_B1s"

# This module support multiple Pre-Defined windows and Windows Distributions.
# Check the README.md file for more pre-defined images for Ubuntu, Centos, RedHat.
# Please make sure to use gen2 images supported VM sizes if you use gen2 distributions
# Specify `disable_password_authentication = false` to create random admin password
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

```

After Modifying the variables, move on to deploying the Shared Services.

### Next step

:arrow_forward: [Deploy the Shared Services](./Shared-Services.md)