# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
SUMMARY: Module to deploy the DevSecOps Spoke in the Landing Zone
DESCRIPTION: The following components will be options in this deployment
             *  DevSecOps Spoke Configuration
             *  Defender Configuration
             *  Key Vault Configuration
             *  Bastion Jumpbox Configuration             
AUTHOR/S: jrspinella
*/

######################################
### DevSecOps Spoke Configuration  ###
######################################

// Resources for the Shared Services Spoke
module "mod_devsecops_network" {
  providers = { azurerm = azurerm.devsecops }
  source    = "azurenoops/overlays-management-spoke/azurerm"
  version   = "5.0.0"

  # By default, this module will create a resource group, provide the name here
  # To use an existing resource group, specify the existing_resource_group_name argument to the existing resource group, 
  # and set the argument to `create_spoke_resource_group = false`. Location will be same as existing RG.
  create_spoke_resource_group = true
  location                    = var.default_location
  deploy_environment          = var.deploy_environment
  org_name                    = var.org_name
  environment                 = var.environment
  workload_name               = var.devsecops_name

  # (Required) Collect Hub Firewall Parameters
  # Hub Firewall details
  existing_hub_firewall_private_ip_address = data.azurerm_firewall.hub-fw.ip_configuration[0].private_ip_address

  # Diagnostic settings for Vnet and Flow Logs
  existing_log_analytics_workspace_resource_id = data.azurerm_log_analytics_workspace.log_analytics.id
  existing_log_analytics_workspace_id          = data.azurerm_log_analytics_workspace.log_analytics.workspace_id

  # Blob Private DNS Id for Storage Account
  existing_private_dns_zone_blob_id = data.azurerm_private_dns_zone.blob.id

  # (Optional) Enable Customer Managed Key for Azure Storage Account
  enable_customer_managed_key = var.enable_customer_managed_keys
  key_vault_resource_id       = var.enable_customer_managed_keys ? module.mod_shared_keyvault.resource.id : null
  key_name                    = var.enable_customer_managed_keys ? module.mod_shared_keyvault.resource.keys["cmk_for_storage_account"].name : null

  # Provide valid VNet Address space for spoke virtual network.    
  virtual_network_address_space = var.devsecops_vnet_address_space # (Required)  Spoke Virtual Network Parameters

  # (Required) Multiple Subnets, Service delegation, Service Endpoints, Network security groups
  # These are default subnets with required configuration, check README.md for more details
  # Route_table and NSG association to be added automatically for all subnets listed here.
  # subnet name will be set as per Azure naming convention by default. expected value here is: <App or project name>
  spoke_subnets = var.devsecops_subnets

  # Enable Flow Logs
  # By default, this will enable flow logs for all subnets.
  enable_traffic_analytics = var.enable_traffic_analytics

  # By default, forced tunneling is enabled for the spoke.
  # If you do not want to enable forced tunneling on the spoke route table, 
  # set `enable_forced_tunneling = false`.
  enable_forced_tunneling_on_route_table = var.enable_forced_tunneling_on_devsecops_route_table

  # (Optional) By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  # lock_level can be set to CanNotDelete or ReadOnly
  enable_resource_locks = var.enable_resource_locks
  lock_level            = var.lock_level

  # Tags
  add_tags = local.devsecops_resources_tags # Tags to be applied to all resources
}

###############################
## Key Vault Configuration  ###
###############################

module "mod_shared_keyvault" {
  providers = { azurerm = azurerm.devsecops }
  source    = "azure/avm-res-keyvault-vault/azurerm"
  version   = "0.5.3"

  # By default, this module will create a resource group and 
  # provide a name for an existing resource group. If you wish 
  # to use an existing resource group, change the option 
  # to "create_key_vault_resource_group = false."   
  resource_group_name = module.mod_devsecops_network.resource_group_name
  location            = var.default_location
  name                = format("%s-%s-%s-%s-kv", var.org_name, module.mod_azregions_lookup.location_short, var.deploy_environment, var.keyvault_name)
  tenant_id           = data.azurerm_client_config.root.tenant_id
  sku_name            = var.keyvault_sku


  # This is to enable the soft delete for the key vault
  soft_delete_retention_days = var.keyvault_soft_delete_retention_days

  # This is to enable the purge protection for the key vault
  purge_protection_enabled = var.keyvault_enabled_for_purge_protection

  # This is to enable the deployments for the key vault
  enabled_for_deployment          = var.keyvault_enabled_for_deployment
  enabled_for_disk_encryption     = var.keyvault_enabled_for_disk_encryption
  enabled_for_template_deployment = var.keyvault_enabled_for_template_deployment

  # This is to enable public access to the key vault, since we are using a private network and endpoint, we will disable it
  public_network_access_enabled = var.keyvault_public_network_access_enabled

  # This is to enable the network access to the key vault
  network_acls = {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = flatten(["${data.http.ip.response_body}/32"], var.keyvault_bypass_ip_cidr)
    virtual_network_subnet_ids = [
      module.mod_devsecops_network.subnet_ids["default"].id
    ]
  }

  # This is to enable the Customer Managed Keys for the key vault
  keys = var.enable_customer_managed_keys ? {
    cmk_for_disks = {
      key_opts = [
        "decrypt",
        "encrypt",
        "sign",
        "unwrapKey",
        "verify",
        "wrapKey"
      ]
      key_type     = "RSA"
      key_vault_id = module.mod_shared_keyvault.resource.id
      name         = "cmk-for-disks"
      key_size     = 2048
    }
    cmk_for_storage_account = {
      key_opts = [
        "decrypt",
        "encrypt",
        "sign",
        "unwrapKey",
        "verify",
        "wrapKey"
      ]
      key_type     = "RSA"
      key_vault_id = module.mod_shared_keyvault.resource.id
      name         = "cmk-for-storage-account"
      key_size     = 2048
    }
  } : {}

  # Contacts for the key vault
  contacts = var.enable_customer_managed_keys ? {
    key_contact = {
      email_address = var.keyvault_contact_email
      name          = var.keyvault_contact_name
      phone         = var.keyvault_contact_phone
    }
  } : {}


  # This is to wait for the RBAC before the key operations
  wait_for_rbac_before_key_operations = var.enable_customer_managed_keys ? {
    create = "60s"
  } : null

  # This is adding the current user as a Key Vault Administrator
  role_assignments = {
    deployment_user_kv_admin = {
      role_definition_id_or_name = "Key Vault Administrator"
      principal_id               = data.azurerm_client_config.root.object_id
    }
    deployment_user_certificates = {
      # give the deployment user access to certificates
      role_definition_id_or_name = "Key Vault Certificates Officer"
      principal_id               = data.azurerm_client_config.root.object_id
    }
    deployment_user_secrets = {
      role_definition_id_or_name = "Key Vault Secrets Officer"
      principal_id               = data.azurerm_client_config.root.object_id
    }
  }

  # This is to enable the Private Endpoint for the key vault
  private_endpoints = {
    "vault" = {
      name                          = format("%s-%s-%s-%s-%s-kv-pe", var.org_name, module.mod_azregions_lookup.location_short, var.devsecops_name, var.deploy_environment, var.keyvault_name)
      subnet_resource_id            = module.mod_devsecops_network.subnet_ids["default"].id
      subresource_name              = ["vault"]
      private_dns_zone_resource_ids = [data.azurerm_private_dns_zone.vault.id]
      # these are optional but illustrate making well-aligned service connection & NIC names.
      private_service_connection_name = format("%s-%s-%s-%s-%s-kv-pe-svc", var.org_name, module.mod_azregions_lookup.location_short, var.devsecops_name, var.deploy_environment, var.keyvault_name)
      network_interface_name          = format("%s-%s-%s-%s-%s-kv-pe-nic", var.org_name, module.mod_azregions_lookup.location_short, var.devsecops_name, var.deploy_environment, var.keyvault_name)
      inherit_tags                    = true
      inherit_lock                    = true
    }
  }

  # This is to enable diagnostic settings for the key vault.
  diagnostic_settings = {
    to_la = {
      name                  = "keyvault-diag"
      workspace_resource_id = module.mod_logging.laws_resource_id
    }
  }

  # This is to enable the secrets for the key vault
  secrets = {
    # The secret value is set in the secrets_value map below
    vm_admin_secret = {
      name            = "jumpbox-admin-password"
      expiration_date = "2028-12-31T23:59:59Z"
      # This is to add role assignments for the secret
      role_assignments = {
        deployment_user_kv_admin = {
          role_definition_id_or_name = "Key Vault Administrator"
          principal_id               = data.azurerm_client_config.root.object_id
        },
        deployment_user_secrets = {
          role_definition_id_or_name = "Key Vault Secrets Officer"
          principal_id               = data.azurerm_client_config.root.object_id
        }
      }
    }
  }

  # This is to add the secrets to the key vault
  secrets_value = {
    vm_admin_secret = var.vm_admin_password
  }

  # This is to wait for the RBAC before the Secret operations
  wait_for_rbac_before_secret_operations = {
    create = "60s"
  }

  # This is to enable resource locks for the key vault. 
  lock = var.enable_resource_locks ? {
    name = format("%s-%s-lock", format("%s-%s-%s-%s-%s-kv", var.org_name, module.mod_azregions_lookup.location_short, var.devsecops_name, var.deploy_environment, var.keyvault_name), var.lock_level)
    kind = var.lock_level
  } : null

  # Telemetry
  enable_telemetry = var.disable_telemetry

  # Tags for Azure Resources
  tags = local.devsecops_resources_tags
}

# Check the private DNS A record for the private endpoint
check "dns" {
  data "azurerm_private_dns_a_record" "assertion" {
    name                = module.mod_shared_keyvault.resource.name
    zone_name           = "privatelink.vaultcore.azure.net"
    resource_group_name = module.mod_hub_network.private_dns_zone_resource_group_name
  }
  assert {
    condition     = one(data.azurerm_private_dns_a_record.assertion.records) == one(module.mod_shared_keyvault.private_endpoints["primary"].private_service_connection).private_ip_address
    error_message = "The private DNS A record for the private endpoint is not correct."
  }
}

#####################################
## Bastion Jumpbox Configuration  ###
#####################################

resource "random_integer" "zone_index" {
  max = length(module.az_regions.regions_by_name[var.default_location].zones)
  min = 1
}

module "mod_bastion_windows_jmp_virtual_machine" {
  providers = { azurerm = azurerm.devsecops }
  source    = "Azure/avm-res-compute-virtualmachine/azurerm"
  version   = "0.11.0"

  # Resource Group, location, VNet and Subnet details
  resource_group_name     = module.mod_devsecops_network.resource_group_name
  location                = var.default_location
  name                    = format("%s-%s-%s-%s-win-jmp-vm", var.org_name, module.mod_azregions_lookup.location_short, var.devsecops_name, var.deploy_environment)
  virtualmachine_sku_size = module.get_valid_sku_for_deployment_region.sku
  zone                    = random_integer.zone_index.result
  computer_name           = "jumpbox-001"

  # Virtual Machine Configuration
  virtualmachine_os_type     = "Windows"
  admin_username             = var.vm_admin_username
  admin_password             = var.vm_admin_password # This is a secret, do not expose it
  encryption_at_host_enabled = false                 # only use when in IL4 or IL5

  # Source Image Reference
  source_image_reference = var.win_source_image_reference

  # Virtual Network Interface Configuration
  network_interfaces = {
    network_interface_jmp = {
      name = format("%s-%s-%s-%s-jmp-nic", var.org_name, module.mod_azregions_lookup.location_short, var.deploy_environment, var.devsecops_name)
      ip_configurations = {
        ip_configuration_jmp = {
          name                          = format("%s-%s-%s-%s-jmp-ipconfig1", var.org_name, module.mod_azregions_lookup.location_short, var.deploy_environment, var.devsecops_name)
          private_ip_subnet_resource_id = module.mod_devsecops_network.subnet_ids["default"].id
        }
      }
      # Diagnostic Settings Configuration
      diagnostic_settings = {
        nic_diags_jmp = {
          name                  = format("%s-%s-%s-%s-jmp-nic-diag", var.org_name, module.mod_azregions_lookup.location_short, var.deploy_environment, var.devsecops_name)
          workspace_resource_id = module.mod_logging.laws_resource_id
          metric_categories     = ["AllMetrics"]
        }
      }
    }
  }

  # Data Disk Configuration
  data_disk_managed_disks = var.data_disks

  # Role Assignment Configuration
  role_assignments = {
    role_assignment_2 = {
      principal_id               = data.azurerm_client_config.root.client_id
      role_definition_id_or_name = "Virtual Machine Contributor"
      description                = "Assign the Virtual Machine Contributor role to the deployment user on this virtual machine resource scope."
    }
  }

  # VM Diagnostic Settings Configuration
  diagnostic_settings = {
    vm_diags = {
      name                        = format("%s-%s-%s-%s-jmp-vm-diag", var.org_name, module.mod_azregions_lookup.location_short, var.deploy_environment, var.devsecops_name)
      workspace_resource_id       = module.mod_logging.laws_resource_id
      storage_account_resource_id = module.mod_devsecops_network.storage_account_id
      metric_categories           = ["AllMetrics"]
    }
  }

  # VM Extension Configuration
  extensions = {
    azure_monitor_agent = {
      name                       = "${module.mod_bastion_jmp_virtual_machine.virtual_machine.name}-azure-monitor-agent"
      publisher                  = "Microsoft.Azure.Monitor"
      type                       = "AzureMonitorWindowsAgent"
      type_handler_version       = "1.0"
      auto_upgrade_minor_version = true
      automatic_upgrade_enabled  = true
      settings                   = null
    }
    azure_disk_encryption = {
      name                       = "${module.mod_bastion_jmp_virtual_machine.virtual_machine.name}-azure-disk-encryption"
      publisher                  = "Microsoft.Azure.Security"
      type                       = "AzureDiskEncryption"
      type_handler_version       = "2.2"
      auto_upgrade_minor_version = true
      settings                   = <<SETTINGS
          {
              "EncryptionOperation": "EnableEncryption",
              "KeyVaultURL": "${module.mod_shared_keyvault.resource.vault_uri}",
              "KeyVaultResourceId": "${module.mod_shared_keyvault.resource.id}",						
              "KeyEncryptionAlgorithm": "RSA-OAEP",
              "VolumeType": "All"
          }
      SETTINGS
    }
  }

  # Resource Lock
  lock = var.enable_resource_locks ? {
    name = format("%s-%s-lock", format("%s-%s-%s-%s-jmp-vm", var.org_name, module.mod_azregions_lookup.location_short, var.deploy_environment, var.devsecops_name), var.lock_level)
    kind = var.lock_level
  } : null

  # Telemetry
  enable_telemetry = var.disable_telemetry

  # Tags for Azure Resources
  tags = local.devsecops_resources_tags
}

module "mod_bastion_linux_jmp_virtual_machine" {
  providers = { azurerm = azurerm.devsecops }
  source    = "Azure/avm-res-compute-virtualmachine/azurerm"
  version   = "0.11.0"

  # Resource Group, location, VNet and Subnet details
  resource_group_name     = module.mod_devsecops_network.resource_group_name
  location                = var.default_location
  name                    = format("%s-%s-%s-%s-linux-jmp-vm", var.org_name, module.mod_azregions_lookup.location_short, var.devsecops_name, var.deploy_environment)
  virtualmachine_sku_size = module.get_valid_sku_for_deployment_region.sku
  zone                    = random_integer.zone_index.result
  computer_name           = "jumpbox-001"

  # Virtual Machine Configuration
  virtualmachine_os_type     = "Linux"
  admin_username             = var.vm_admin_username
  admin_password             = var.vm_admin_password # This is a secret, do not expose it
  encryption_at_host_enabled = false                 # only use when in IL4 or IL5

  # Source Image Reference
  source_image_reference = var.linux_source_image_reference

  # Virtual Network Interface Configuration
  network_interfaces = {
    network_interface_jmp = {
      name = format("%s-%s-%s-%s-jmp-nic", var.org_name, module.mod_azregions_lookup.location_short, var.deploy_environment, var.devsecops_name)
      ip_configurations = {
        ip_configuration_jmp = {
          name                          = format("%s-%s-%s-%s-jmp-ipconfig1", var.org_name, module.mod_azregions_lookup.location_short, var.deploy_environment, var.devsecops_name)
          private_ip_subnet_resource_id = module.mod_devsecops_network.subnet_ids["default"].id
        }
      }
      # Diagnostic Settings Configuration
      diagnostic_settings = {
        nic_diags_jmp = {
          name                  = format("%s-%s-%s-%s-jmp-nic-diag", var.org_name, module.mod_azregions_lookup.location_short, var.deploy_environment, var.devsecops_name)
          workspace_resource_id = module.mod_logging.laws_resource_id
          metric_categories     = ["AllMetrics"]
        }
      }
    }
  }

  # Data Disk Configuration
  data_disk_managed_disks = var.data_disks

  # Role Assignment Configuration
  role_assignments = {
    role_assignment_2 = {
      principal_id               = data.azurerm_client_config.root.client_id
      role_definition_id_or_name = "Virtual Machine Contributor"
      description                = "Assign the Virtual Machine Contributor role to the deployment user on this virtual machine resource scope."
    }
  }

  # VM Diagnostic Settings Configuration
  diagnostic_settings = {
    vm_diags = {
      name                        = format("%s-%s-%s-%s-jmp-vm-diag", var.org_name, module.mod_azregions_lookup.location_short, var.deploy_environment, var.devsecops_name)
      workspace_resource_id       = module.mod_logging.laws_resource_id
      storage_account_resource_id = module.mod_devsecops_network.storage_account_id
      metric_categories           = ["AllMetrics"]
    }
  }

  # VM Extension Configuration
  extensions = {
    azure_monitor_agent = {
      name                       = "${module.mod_bastion_jmp_virtual_machine.virtual_machine.name}-azure-monitor-agent"
      publisher                  = "Microsoft.Azure.Monitor"
      type                       = "AzureMonitorWindowsAgent"
      type_handler_version       = "1.0"
      auto_upgrade_minor_version = true
      automatic_upgrade_enabled  = true
      settings                   = null
    }
    azure_disk_encryption = {
      name                       = "${module.mod_bastion_jmp_virtual_machine.virtual_machine.name}-azure-disk-encryption"
      publisher                  = "Microsoft.Azure.Security"
      type                       = "AzureDiskEncryption"
      type_handler_version       = "2.2"
      auto_upgrade_minor_version = true
      settings                   = <<SETTINGS
          {
              "EncryptionOperation": "EnableEncryption",
              "KeyVaultURL": "${module.mod_shared_keyvault.resource.vault_uri}",
              "KeyVaultResourceId": "${module.mod_shared_keyvault.resource.id}",						
              "KeyEncryptionAlgorithm": "RSA-OAEP",
              "VolumeType": "All"
          }
      SETTINGS
    }
  }

  # Resource Lock
  lock = var.enable_resource_locks ? {
    name = format("%s-%s-lock", format("%s-%s-%s-%s-jmp-vm", var.org_name, module.mod_azregions_lookup.location_short, var.deploy_environment, var.devsecops_name), var.lock_level)
    kind = var.lock_level
  } : null

  # Telemetry
  enable_telemetry = var.disable_telemetry

  # Tags for Azure Resources
  tags = local.devsecops_resources_tags
}
