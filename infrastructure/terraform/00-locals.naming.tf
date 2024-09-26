# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.


# The following locals are used to define the network & short names
locals {
  hubName                       = "hub"
  hub_short_name                = "hub"
  identity_name                 = "identity"
  identity_short_name           = "id"
  operations_name               = "operations"
  operations_short_name         = "ops"
  operations_logging_name       = "logging"
  operations_logging_short_name = "logging"
  security_name                 = "security"
  security_short_name           = "sec"
  devsecops_mame                = "devsecops"
  devsecops_short_name          = "devsecops"
}

locals {
  # The following locals are used to define the resource names
  # Key Vault
  key_vault_name        = data.azurenoopsutils_resource_name.kv.result
  key_vault_diags_name  = data.azurenoopsutils_resource_name.kv_diags_name.result
  pe_key_vault_name     = data.azurenoopsutils_resource_name.pe_kv_name.result
  pe_key_vault_psc_name = data.azurenoopsutils_resource_name.pe_kv_psc_name.result
  pe_key_vault_nic_name = data.azurenoopsutils_resource_name.pe_kv_nic_name.result
  key_vault_lock_name   = format("%s-%s-lock", format("%s-%s-%s-%s-%s-kv", var.org_name, module.mod_azregions_lookup.location_short, local.devsecops_short_name, var.deploy_environment, var.keyvault_name), var.lock_level)
  cmk_user_assigned_identity_name = format("%s-%s-%s-%s-cmk-msi", var.org_name, module.mod_azregions_lookup.location_short, var.deploy_environment, local.devsecops_short_name)
  

  # Windows VM
  windows_vm_name            = data.azurenoopsutils_resource_name.windows_jmp_name.result
  windows_computer_name      = "win-jumpbox-001"
  windows_vm_disk_name       = format("%s-%s-%s-%s-win-jmp-disk-lund0", var.org_name, module.mod_azregions_lookup.location_short, var.deploy_environment, local.devsecops_short_name)
  windows_nic_name           = data.azurenoopsutils_resource_name.windows_nic_name.result
  windows_nic_ipconfig_name  = format("%s-%s-%s-%s-win-jmp-ipconfig1", var.org_name, module.mod_azregions_lookup.location_short, var.deploy_environment, local.devsecops_short_name)
  windows_nic_diags_jmp_name = format("%s-%s-%s-%s-win-jmp-nic-diag", var.org_name, module.mod_azregions_lookup.location_short, var.deploy_environment, local.devsecops_short_name)
  windows_vm_diags_name      = format("%s-%s-%s-%s-win-jmp-vm-diag", var.org_name, module.mod_azregions_lookup.location_short, var.deploy_environment, local.devsecops_short_name)
  windows_lock_name          = format("%s-%s-lock", format("%s-%s-%s-%s-win-jmp-vm", var.org_name, module.mod_azregions_lookup.location_short, var.deploy_environment, local.devsecops_short_name), var.lock_level)
  
  vm_user_assigned_identity_name = format("%s-%s-%s-%s-vm-msi", var.org_name, module.mod_azregions_lookup.location_short, var.deploy_environment, local.devsecops_short_name)
  vm_disk_encryption_set_name    = format("%s-%s-%s-%s-vm-des", var.org_name, module.mod_azregions_lookup.location_short, var.deploy_environment, local.devsecops_short_name)
}