#############################
### Naming Configuations  ###
#############################
data "azurenoopsutils_resource_name" "bastion_vm" {
  name          = "svcs"
  resource_type = "azurerm_linux_virtual_machine"
  prefixes      = [local.org_name, module.mod_azure_region_lookup.location_short]
  suffixes      = [local.deploy_environment, "bas"]
  use_slug      = true
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "bastion_nic" {
  name          = "svcs"
  resource_type = "azurerm_network_interface"
  prefixes      = [local.org_name, module.mod_azure_region_lookup.location_short]
  suffixes      = [local.deploy_environment, "bas"]
  use_slug      = true
  clean_input   = true
  separator     = "-"
}
