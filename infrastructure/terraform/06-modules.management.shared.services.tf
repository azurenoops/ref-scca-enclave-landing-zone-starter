# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

################################
### Hub/Spoke Configuations  ###
################################

/* module "shared_services" {
  source = "./modules/06-shared_services"

  # Global Configuration
  required                = var.required
  location                = var.default_location
  state_sa_rg             = local.state_sa_rg
  state_sa_name           = local.state_sa_name
  state_sa_container_name = local.state_sa_container_name
  subscription_id_hub     = var.subscription_id_hub

  # Key Vault Configuration
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  admin_group_name                = var.admin_group_name

  # Bastion VM Configuration
} */
