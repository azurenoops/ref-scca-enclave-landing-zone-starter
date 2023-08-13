# Deploying the Mission Enclave Landing Zone starter using manual deployment

## Table of Contents

- [Prerequisites](#prerequisites)
- [Quickstart](#quickstart)
- [Planning](#planning)  
- [Deployment](#deployment)  
- [Cleanup](#cleanup)  
- [Development Setup](#development-setup)  
- [See Also](#see-also) 

This guide describes how to deploy Mission Enclave Landing Zone starter using the [Terraform](https://www.terraform.io/) template at [infrastructure/terraform/](../src/terraform).

To get started with Terraform on Azure check out their [tutorial](https://learn.hashicorp.com/collections/terraform/azure-get-started/).

## Prerequisites

- Current version of the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- The version of the [Terraform CLI](https://www.terraform.io/downloads.html) described in the [.devcontainer Dockerfile](../.devcontainer/Dockerfile)
- An Azure Subscription(s) where you or an identity you manage has `Owner` [RBAC permissions](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#owner)

<!-- markdownlint-disable MD013 -->
> NOTE: Azure Cloud Shell is often our preferred place to deploy from because the AZ CLI and Terraform are already installed. However, sometimes Cloud Shell has different versions of the dependencies from what we have tested and verified, and sometimes there have been bugs in the Terraform Azure RM provider or the AZ CLI that only appear in Cloud Shell. If you are deploying from Azure Cloud Shell and see something unexpected, try the [development container](../.devcontainer) or deploy from your machine using locally installed AZ CLI and Terraform. We welcome all feedback and [contributions](../CONTRIBUTING.md), so if you see something that doesn't make sense, please [create an issue](https://github.com/Azure/missionlz/issues/new/choose) or open a [discussion thread](https://github.com/Azure/missionlz/discussions).
<!-- markdownlint-enable MD013 -->

## Quickstart

Below is an example of a Terraform deployment that uses all the defaults in the [TFVARS folder](./../infrastructure/terraform/tfvars) to deploy the landing zone to one subscription.

>NOTE: Since this reference implementation is designed to use remote state, you will need to comment out the `backend "local" {}` block in the [versions.tf](./../infrastructure/terraform/versions.tf) file. This will allow you to deploy the landing zone without having to deploy the remote state storage account first.

```bash
cd infrastructure/terraform
terraform init
terraform plan --out anoa.dev.plan --var-file tfvars/parameters.tfvars --var "subscription_id_hub=<<subscription_id>>" --var "vm_admin_password=<<vm password>>" # supply some parameters, approve, copy the output values
terraform apply anoa.dev.plan
```

## Planning

If you want to change the default values, you can do so by editing the [parameters.tfvars](./tfvars/parameters.tfvars) file. The following sections describe the parameters that can be changed.

### One Subscription or Multiple

MLZ can deploy to a single subscription or multiple subscriptions. A test and evaluation deployment may deploy everything to a single subscription, and a production deployment may place each tier into its own subscription.

The optional parameters related to subscriptions are below. At least one subscription is required.

Parameter name | Default Value | Description
-------------- | ------------- | -----------
`hub_subid` | '' | Subscription ID for the Hub deployment
`tier0_subid` | value of hub_subid | Subscription ID for tier 0
`tier1_subid` | value of hub_subid | Subscription ID for tier 1
`tier2_subid` | value of hub_subid | Subscription ID for tier 2

### Mission Enclave Landing Zone Remote State Storage Account

The remote state storage account is used to store the Terraform state files. The state files contain the current state of the infrastructure that has been deployed. The state files are used by Terraform to determine what changes need to be made to the infrastructure when a deployment is run. The remote state storage account is also used to store the Terraform state lock files. The lock files are used to prevent multiple deployments from running at the same time. The remote state storage account is created in the hub subscription.

To find out more about remote state, see the [Remote State documentation](./07-Remote-State-Storage.md).

### Mission Enclave Landing Zone Global Configuration

Review and if needed, comment out and modify the variables within the "01 Global Configuration" section of the common variable definitons file [parameters.tfvars](./tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Sample:

```bash

##############################
## 01 Global Configuration  ##
##############################

# The prefixes to use for all resources in this deployment
org_name           = "anoa"   # This Prefix will be used on most deployed resources.  10 Characters max.
deploy_environment = "dev"    # dev | test | prod
environment        = "public" # public | usgovernment

# The default region to deploy to
default_location = "eastus"

# Enable locks on resources
enable_resource_locks = false # true | false

# Enable NSG Flow Logs
# By default, this will enable flow logs traffic analytics for all subnets.
enable_traffic_analytics = true

```

### Mission Enclave Management Groups

Review and if needed, comment out and modify the variables within the "02 Management Groups Configuration" section of the common variable definitons file [parameters.tfvars](./tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Sample:

```bash

########################################
# 02 Management Groups Configuration  ##
########################################

enable_management_groups           = true   # enable management groups for this subscription
root_management_group_id           = "anoa" # the root management group id for this subscription
root_management_group_display_name = "anoa" # the root management group display name for this subscription

# Management groups to create
# The management group structure is created in the locals.tf file

```

Main managment group structure is located in locals.tf at the root (terraform) folder. It uses the 'root_management_group_id' for the top level groups. Modify the following to meet your needs.

```terraform
# The following locals are used to define the management groups
locals {
  management_groups = {
    platforms = {
      display_name               = "platforms"
      management_group_name      = "platforms"
      parent_management_group_id = "${local.root_id}"
      subscription_ids           = []
    },
    workloads = {
      display_name               = "workloads"
      management_group_name      = "workloads"
      parent_management_group_id = "${local.root_id}"
      subscription_ids           = []
    },
    sandbox = {
      display_name               = "sandbox"
      management_group_name      = "sandbox"
      parent_management_group_id = "${local.root_id}"
      subscription_ids           = []
    },
    transport = {
      display_name               = "transport"
      management_group_name      = "transport"
      parent_management_group_id = "platforms"
      subscription_ids           = []
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

```

### Mission Enclave Management Budgets

Review and if needed, comment out and modify the variables within the "02 Management Groups Budgets Configuration" section of the common variable definitons file [parameters.tfvars](./tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Sample:

```bash

################################################
# 03 Management Groups Budgets Configuration  ##
################################################

# Budgets for management groups
enable_management_groups_budgets = false                  # enable budgets for management groups
budget_contact_emails            = ["anoa@microsoft.com"] # email addresses to send alerts to for this subscription

```

### Mission Enclave Management Roles

Review and if needed, comment out and modify the variables within the "04 Management Groups Roles Configuration" section of the common variable definitons file [parameters.tfvars](./tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Sample:

```bash

################################################
# 04 Management Groups Roles Configuration  ##
################################################

deploy_custom_roles = true # true | false

```

Main roles structure is located in locals.tf at the root (terraform) folder. It uses the 'data.azurerm_client_config.current.subscription_id' for the scope of the roles. Modify the following to meet your needs.

```terraform

custom_role_definitions = [
  {
    role_definition_name = "Custom - Network Operations (NetOps)"
    scope                = "${data.azurerm_client_config.current.subscription_id}" ## This setting is optional. (If not defined current subscription ID is used).
    description          = "Platform-wide global connectivity management: virtual networks, UDRs, NSGs, NVAs, VPN, Azure ExpressRoute, and others."
    permissions = {
      actions = [
        "Microsoft.Network/virtualNetworks/read",
        "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/read",
        "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/write",
        "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/delete",
        "Microsoft.Network/virtualNetworks/peer/action",
        "Microsoft.Resources/deployments/operationStatuses/read",
        "Microsoft.Resources/deployments/write",
        "Microsoft.Resources/deployments/read"
      ]
      data_actions     = []
      not_actions      = []
      not_data_actions = []
    }
    assignable_scopes = [["${module.mod_management_group.0.management_groups["/providers/Microsoft.Management/managementGroups/platforms"].id}"]] ## This setting is optional. (If not defined current subscription ID is used).
  }
]

```

## Deployment

### Login to Azure CLI

Log in using the Azure CLI.

```BASH
az login
```

If you are deploying to another cloud, such as Azure Government, set the cloud name before logging in.

  ```BASH
  az cloud set -n AzureUSGovernment
  az login
  ```

### Terraform init

Before provisioning any Azure resources with Terraform you must [initialize a working directory](https://www.terraform.io/docs/cli/commands/init.html/).

1. Navigate to the directory in the repository that contains the MissionLZ Terraform module:

    ```bash
    cd src/terraform/mlz
    ```

1. Execute `terraform init`

    ```bash
    terraform init
    ```

### Terraform apply

After intializing the directory, use [`terraform apply`](https://www.terraform.io/docs/cli/commands/apply.html) to provision the resources described in `mlz/main.tf` and its referenced modules at `mlz/modules/*`.

When you run `terraform apply`, by default, Terraform will inspect the state of your environment to determine what resource creation, modification, or deletion needs to occur as if you invoked a [`terraform plan`](https://www.terraform.io/docs/cli/commands/plan.html) and then prompt you for your approval before taking action.

1. From the directory in which you executed `terraform init` execute `terraform apply`:

    ```bash
    terraform apply
    ```

1. You'll be prompted for a subscription ID. Supply the subscription ID you want to use for the Hub network:

    ```plaintext
    > terraform apply
    var.hub_subid
    Subscription ID for the deployment

    Enter a value: 
    ```

1. Terraform will then inspect the state of your Azure environment and compare it with what is described in the Mission LZ Terraform module. Eventually, you'll be prompted for your approval to create, modify, or destroy resources. Supply `yes`:

    ```plaintext
    Do you want to perform these actions?
      Terraform will perform the actions described above.
      Only 'yes' will be accepted to approve.

    Enter a value: yes
    ```

1. The deployment will begin. These commands will deploy all of the resources that make up Mission LZ. Deployment could take up to 45 minutes.

### Apply Complete

When it's complete, you'll see some output values that will be necessary if you want to stand up new spoke, or Tier 3, networks:

```plaintext
Apply complete! Resources: 99 added, 0 changed, 0 destroyed.

Outputs:

firewall_private_ip = "10.0.100.4"
hub_rgname = "hub-rg"
hub_subid = "{the Hub subscription ID}"
hub_vnetname = "hub-vnet"
laws_name = "{the name of the Log Analytics Workspace}"
laws_rgname = "operations-rg"
tier1_subid = "{the Tier 1 subscription ID}"
```

