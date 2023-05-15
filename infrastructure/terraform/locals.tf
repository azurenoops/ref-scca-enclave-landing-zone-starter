# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

locals {
  state_sa_name           = var.state_sa_name
  state_sa_rg             = var.state_sa_rg
  state_sa_container_name = var.state_sa_container_name
}

# The following locals are used to define the management groups
locals {
  management_groups = {
    platforms = {
      display_name               = "platforms"
      management_group_name      = "platforms"
      parent_management_group_id = "${var.root_management_group_id}"
      subscription_ids           = []
    },
    workloads = {
      display_name               = "workloads"
      management_group_name      = "workloads"
      parent_management_group_id = "${var.root_management_group_id}"
      subscription_ids           = []
    },
    sandbox = {
      display_name               = "sandbox"
      management_group_name      = "sandbox"
      parent_management_group_id = "${var.root_management_group_id}"
      subscription_ids           = []
    },
    transport = {
      display_name               = "transport"
      management_group_name      = "transport"
      parent_management_group_id = "platforms"
      subscription_ids           = ["${var.subscription_id_hub}"]
    },
    internal = {
      display_name               = "internal"
      management_group_name      = "internal"
      parent_management_group_id = "workloads"
      subscription_ids           = []
    }
    partners = {
      display_name               = "partners"
      management_group_name      = "partners"
      parent_management_group_id = "workloads"
      subscription_ids           = []
    }
  }
}
