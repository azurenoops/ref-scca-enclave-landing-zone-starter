# Deploying the Mission Enclave Landing Zone starter using manual deployment

## Table of Contents

- [Prerequisites](#prerequisites)
- [Quickstart](#quickstart)
- [Planning](#planning)  
- [Deployment](#deployment)  
- [Cleanup](#cleanup)  
- [Development Setup](#development-setup)  
- [See Also](#see-also)

This guide describes how to deploy Mission Enclave Landing Zone starter using the [Terraform](https://www.terraform.io/) modules at [infrastructure/terraform/](../infrastructure/terraform/).

To get started with Terraform on Azure check out their [tutorial](https://learn.hashicorp.com/collections/terraform/azure-get-started/).

## Prerequisites

- Current version of the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- The version of the [Terraform CLI](https://www.terraform.io/downloads.html) described in the [.devcontainer Dockerfile](../.devcontainer/Dockerfile)
- An Azure Subscription(s) where you or an identity you manage has `Owner` [RBAC permissions](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#owner)

<!-- markdownlint-disable MD013 -->
> NOTE: Azure Cloud Shell is often our preferred place to deploy from because the AZ CLI and Terraform are already installed. However, sometimes Cloud Shell has different versions of the dependencies from what we have tested and verified, and sometimes there have been bugs in the Terraform Azure RM provider or the AZ CLI that only appear in Cloud Shell. If you are deploying from Azure Cloud Shell and see something unexpected, try the [development container](../.devcontainer) or deploy from your machine using locally installed AZ CLI and Terraform. We welcome all feedback and [contributions](../CONTRIBUTING.md), so if you see something that doesn't make sense, please [create an issue](https://github.com/AzureNoOps/ref-scca-enclave-landing-zone-starter/issues/new/choose) or open a [discussion thread](https://github.com/AzureNoOps/ref-scca-enclave-landing-zone-starter/discussions).
<!-- markdownlint-enable MD013 -->

## Quickstart

Below is an example of a Terraform deployment that uses all the defaults in the [TFVARS folder](./../infrastructure/terraform/tfvars/parameters.tfvars) to deploy the landing zone to one subscription.

>NOTE: Since this reference implementation is designed to use remote state, you will need to comment out the `backend "local" {}` block in the [versions.tf](./../infrastructure/terraform/versions.tf) file. This will allow you to deploy the landing zone without having to deploy the remote state storage account first.

```bash
cd infrastructure/terraform
terraform init
terraform plan --out anoa.dev.plan --var-file tfvars/parameters.tfvars --var "subscription_id_hub=<<subscription_id>>" --var "vm_admin_password=<<vm password>>" # supply some parameters, approve, copy the output values
terraform apply anoa.dev.plan
```

## Planning

If you want to change the default values, you can do so by editing the [parameters.tfvars](../infrastructure/terraform/tfvars/parameters.tfvars) file. The following sections describe the parameters that can be changed.

### One Subscription or Multiple

Mission Enclave Landing Zone starter can deploy to a single subscription or multiple subscriptions. A test and evaluation deployment may deploy everything to a single subscription, and a production deployment may place each tier into its own subscription.

The optional parameters related to subscriptions are below. At least one subscription is required.

Parameter name | Default Value | Description
-------------- | ------------- | -----------
`subscription_id_hub` | '' | Subscription ID for the Hub deployment
`subscription_id_identity` | value of hub_subid | Subscription ID for tier 0
`subscription_id_operations` | value of hub_subid | Subscription ID for tier 1
`subscription_id_devsecops` | value of hub_subid | Subscription ID for tier 2

### Mission Enclave Landing Zone Remote State Storage Account

The remote state storage account is used to store the Terraform state files. The state files contain the current state of the infrastructure that has been deployed. The state files are used by Terraform to determine what changes need to be made to the infrastructure when a deployment is run. The remote state storage account is also used to store the Terraform state lock files. The lock files are used to prevent multiple deployments from running at the same time. The remote state storage account is created in the hub subscription.

To find out more about remote state, see the [Remote State documentation](./07-Remote-State-Storage.md).

### Mission Enclave Landing Zone Global Configuration

Review and if needed, comment out and modify the variables within the "01 Global Configuration" section of the common variable definitions file [parameters.tfvars](../infrastructure/terraform/tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Sample Configuration:

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

Review and if needed, comment out and modify the variables within the "02 Management Groups Configuration" section of the common variable definitions file [parameters.tfvars](../infrastructure/terraform/tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

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

Main management group structure is located in locals.tf at the root (terraform) folder. It uses the 'root_management_group_id' for the top level groups. Modify the following to meet your needs.

```terraform
# The following locals are used to define the management groups
locals {
  management_groups = {
    platforms = {
      display_name               = "platforms"
      management_group_name      = "platforms"
      parent_management_group_id = "anoa"
      subscription_ids           = []
    },
    workloads = {
      display_name               = "workloads"
      management_group_name      = "workloads"
      parent_management_group_id = "anoa"
      subscription_ids           = []
    },
    sandbox = {
      display_name               = "sandbox"
      management_group_name      = "sandbox"
      parent_management_group_id = "anoa"
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

Review and if needed, comment out and modify the variables within the "02 Management Groups Budgets Configuration" section of the common variable definitions file [parameters.tfvars](../infrastructure/terraform/tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Sample:

```bash

################################################
# 03 Management Groups Budgets Configuration  ##
################################################

# Budgets for management groups
enable_management_groups_budgets = false                  # enable budgets for management groups
budget_contact_emails            = ["anoa@contoso.com"] # email addresses to send alerts to for this subscription

```

### Mission Enclave Management Roles

Review and if needed, comment out and modify the variables within the "04 Management Groups Roles Configuration" section of the common variable definitions file [parameters.tfvars](../infrastructure/terraform/tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

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

### Mission Enclave - Management Hub Virtual Network

The following will be created:

- Resource Group for Management Hub Networking (main.tf)
- Management Hub Network (main.tf)
- Management Hub Subnets (main.tf)

Review and if needed, comment out and modify the variables within the "Landing Zone Configuration" section under "Management Hub Virtual Network" of the common variable definitions file [parameters.tfvars](../infrastructure/terraform/tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Sample:

```bash

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
ampls_subnet_address_prefixes       = ["10.8.5.160/27"]   # (Required)  AMPLS Subnet Parameter
fw_management_snet_address_prefixes = ["10.8.4.128/26"] # (Optional)  Hub Firewall Management Subnet Parameters. If not provided, force_tunneling is not needed.
gateway_vnet_address_space          = ["10.8.4.0/27"]   # (Optional)  Hub Gateway Subnet Parameters

# (Required) Hub Subnets 
# Default Subnets, Service Endpoints
# This is the default subnet with required configuration, check README.md for more details
# First address ranges from VNet Address space reserved for Firewall Subnets. 
# First three address ranges from VNet Address space reserved for Gateway, AMPLS And Firewall Subnets. 
# These are default subnets with required configuration, check README.md for more details
# NSG association to be added automatically for all subnets listed here.
# subnet name will be set as per Azure naming convention by default. expected value here is: <App or project name>
hub_subnets = {
  default = {
    name                                       = "hub-core"
    address_prefixes                           = ["10.8.4.224/27"]
    service_endpoints                          = ["Microsoft.Storage"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true
  }

  dmz = {
    name                                       = "app-gateway"
    address_prefixes                           = ["10.8.5.64/27"]
    service_endpoints                          = ["Microsoft.Storage"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true
    nsg_subnet_inbound_rules = [
      # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
      # To use defaults, use "" without adding any value and to use this subnet as a source or destination prefix.
      # 65200-65335 port to be opened if you planning to create application gateway
      ["http", "100", "Inbound", "Allow", "Tcp", "80", "*", ["0.0.0.0/0"]],
      ["https", "200", "Inbound", "Allow", "Tcp", "443", "*", [""]],
      ["appgwports", "300", "Inbound", "Allow", "Tcp", "65200-65335", "*", [""]],

    ]
    nsg_subnet_outbound_rules = [
      # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
      # To use defaults, use "" without adding any value and to use this subnet as a source or destination prefix.
      ["ntp_out", "400", "Outbound", "Allow", "Udp", "123", "", ["0.0.0.0/0"]],
    ]
  }
}

```

### Mission Enclave - Management Hub Operational Logging

The following will be created:

- Log Analytics (main.tf)
- Log Solutions (main.tf)

Review and if needed, comment out and modify the variables within the "Landing Zone Configuration" section under "Operational Logging" of the common variable definitions file [parameters.tfvars](../infrastructure/terraform/tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Sample:

```bash

################################
# Landing Zone Configuration  ##
################################

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

```

### Mission Enclave - Azure Firewall Resource

The following will be created:

- Azure Firewall (main.tf)
- Required Firewall rules (main.tf)

Review and if needed, comment out and modify the variables within the "Landing Zone Configuration" section under "Management Hub Firewall" of the common variable definitions file [parameters.tfvars](../infrastructure/terraform/tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Sample:

```bash

################################
# Landing Zone Configuration  ##
################################

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

```

### Mission Enclave - Bastion/Private DNS Zones

The following will be created:

- Azure Bastion (main.tf)
- Private DNS Zones (main.tf)

Review and if needed, comment out and modify the variables within the "Landing Zone Configuration" section under "Bastion/Private DNS Zones" of the common variable definitions file [parameters.tfvars](../infrastructure/terraform/tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Sample:

```bash

################################
# Landing Zone Configuration  ##
################################

###################################
# 05c Bastion/Private DNS Zones ###
###################################

# Private DNS Zone Settings
# By default, Azure NoOps will create Private DNS Zones for Logging in Hub VNet.
# If you do want to create additional Private DNS Zones, 
# add in the list of private_dns_zones to be created.
# else, remove the private_dns_zones argument.
hub_private_dns_zones = ["privatelink.file.core.windows.net"]

# By default, this module will create a bastion host, 
# and set the argument to `enable_bastion_host = false`, to disable the bastion host.
enable_bastion_host                 = true
azure_bastion_host_sku              = "Standard"
azure_bastion_subnet_address_prefix = ["10.8.4.192/27"]

```

### Mission Enclave - Identity Management Spoke Virtual Network

The following will be created:

- Resource Groups for Identity Spoke Networking
- Spoke Networks (Identity)

Review and if needed, comment out and modify the variables within the "Landing Zone Configuration" section under "Identity Management Spoke Virtual Network" of the common variable definitions file [parameters.tfvars](../infrastructure/terraform/tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Sample:

```bash

################################
# Landing Zone Configuration  ##
################################

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

```

### Mission Enclave - Operations Management Spoke Virtual Network

The following will be created:

- Resource Groups for Operations Spoke Networking
- Spoke Networks (Operations)

Review and if needed, comment out and modify the variables within the "Landing Zone Configuration" section under "Operations Management Spoke Virtual Network" of the common variable definitions file [parameters.tfvars](../infrastructure/terraform/tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Sample:

```bash

################################
# Landing Zone Configuration  ##
################################

####################################################
# 5d Operations Management Spoke Virtual Network ###
####################################################

# Enable Operations Management Spoke Virtual Network
# If you do not want to create Operations Management Spoke Virtual Network,
# remove this section from the configuration file.

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

```

### Mission Enclave - DevSecOps Management Spoke Virtual Network

The following will be created:

- Resource Groups for DevSecOps Spoke Networking
- Spoke Networks (DevSecOps)

Review and if needed, comment out and modify the variables within the "Landing Zone Configuration" section under "DevSecOps Management Spoke Virtual Network" of the common variable definitions file [parameters.tfvars](../infrastructure/terraform/tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Sample:

```bash

################################
# Landing Zone Configuration  ##
################################

####################################################
# 5d DevSecOps Management Spoke Virtual Network ###
####################################################

# Enable DevSecOps Management Spoke Virtual Network
# If you do not want to create DevSecOps Management Spoke Virtual Network,
# remove this section from the configuration file.

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

```

## Deployment

Mission Enclave Landing Zone can be deployed with command-line tools provided with the Terraform CLI in PowerShell.

### Command Line Deployment Using the Terraform CLI in PowerShell

Use the Terraform CLI command `terraform` to deploy Mission Enclave Landing Zone across one or many subscriptions. The following sections describe how to deploy Mission Enclave Landing Zone using the Terraform CLI in PowerShell.

### Single Subscription Deployment

To deploy Mission Enclave Landing Zone into a single subscription, you must first login to Azure.

### Login to Azure CLI

Log in using the Azure CLI.

```BASH
# AZ CLI
az cloud set -n AzureCloud
az login
```

### Set the Environment

```BASH
# AZ CLI
$env:ARM_ENVIRONMENT = "public"
```

>NOTE: If you are deploying to Azure US Government, set the environment to `usgovernment`.

### Terraform init

Before provisioning any Azure resources with Terraform you must [initialize a working directory](https://www.terraform.io/docs/cli/commands/init.html/).

1. Navigate to the directory in the repository that contains the Mission Enclave Landing Zone Starter Terraform modules and configuration files:

    ```bash
    cd infrastructure/terraform
    ```

>NOTE: Since this reference implementation is designed to use remote state, you will need to comment out the `backend "local" {}` block in the [versions.tf](./../infrastructure/terraform/versions.tf) file. This will allow you to deploy the landing zone without having to deploy the remote state storage account first. For more information on remote state, see the [Remote State documentation](../docs/07-Remote-State-Storage.md).

1. Execute `terraform init`

    ```bash
    terraform init
    ```

### Terraform Plan

After initializing the directory, use [`terraform plan`](https://www.terraform.io/docs/cli/commands/plan.html) to provision the resources plan described in `infrastructure/terraform`.

1. From the directory in which you executed `terraform init` execute `terraform plan` with the `--var-file` parameter to specify the path to the `parameters.tfvars` file:

    ```bash
    terraform apply --var-file tfvars/parameters.tfvars --out "anoa.dev.plan"
    ```

1. You'll be prompted for a Hub subscription ID and VM Password.

    Supply the subscription ID you want to use for the Hub network:

    ```plaintext
    > terraform plan
    var.subscription_id_hub
    If specified, identifies the Platform subscription for "Hub" for resource deployment and correct placement in the Management Group hierarchy.

    Enter a value:

    Supply the VM Admin Password you want to use for the Bastion VM:

    ```plaintext
    var.vm_admin_password
    The password for the administrator account for the Bastion VM.

    Enter a value:
    ```

 >*NOTE:* If you want to skip the prompts, you can supply the values on the command line using the `--var` parameter. For more information, see the [Terraform CLI documentation](https://www.terraform.io/docs/cli/commands/plan.html#var).

### Terraform Apply

Now run `terraform apply`, by default, Terraform will inspect the state of your environment to determine what resource creation, modification, or deletion needs to occur from the [`terraform plan`](https://www.terraform.io/docs/cli/commands/plan.html) using the output plan and then prompt you for your approval before taking action.

1. From the directory in which you executed `terraform init` execute `terraform apply` with the `anoa.de.plan` parameter:

    ```bash
    terraform apply "anoa.dev.plan"
    ```

>NOTE: Since you are using a output plan file, you will not be prompted for approval to deploy.

1. The deployment will begin. These commands will deploy all of the resources that make up Mission Enclave LZ. Deployment could take up to 45 minutes.

### Apply Complete

When it's complete, you'll see some output values that will be necessary if you want to stand up new workload spoke, or add-on:

```plaintext
Apply complete! Resources: 166 added, 0 changed, 0 destroyed.

Example Outputs:

hub_virtual_network_id = /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/anoa-hub-networking-rg/providers/Microsoft.Network/virtualNetworks/anoa-hub-vnet
hub_virtual_network_name = "anoa-hub-core-dev-vnet"
firewall_private_ip = "0.0.0.0"
log_analytics_workspace_id = /subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/anoa-hub-networking-rg/providers/microsoft.operationalinsights/workspaces/anoa-hub-logs-dev-law
...
```

### Deploying to Other Clouds

When deploying to another cloud, like Azure US Government, first set the cloud and log in.

Logging into `AzureUSGovernment`:

```BASH
# AZ CLI
az cloud set -n AzureUsGovernment
az login
```

### Deploying to Multiple Subscriptions

To deploy Mission Enclave Landing Zone into multiple subscriptions, follow the same steps as deploying to Single Subscription. The only difference is that you will need to add the subscription ID for each subscription you are deploying to on the [`terraform plan`](https://www.terraform.io/docs/cli/commands/plan.html).

Example:

```plaintext
> terraform plan --var-file tfvars/parameters.tfvars --out "anoa.dev.plan" -var "subscription_id_hub=00000000-0000-0000-0000-000000000000" -var "subscription_id_identity=00000000-0000-0000-0000-000000000000" -var "subscription_id_operations="\00000000-0000-0000-0000-000000000000" -var "subscription_id_devsecops=00000000-0000-0000-0000-000000000000" -var "vm_admin_password=Password1234!"
```

## Cleanup

If you want to delete an Mission Enclave Landing Zone deployment you can use [`terraform destroy`](https://www.terraform.io/docs/cli/commands/destroy.html). If you have deployed more than one Terraform template, e.g., if you have deployed `Landing Zone` and then `Add-on`, run the `terraform destroy` commands in the reverse order that you applied them. For example:

```bash
# Deploy core MLZ resources
cd infrastructure/terraform
terraform apply

# Destroy core MLZ resources
cd infrastructure/terraform
terraform destroy
```

Running `terraform destroy` for `infrastructure/terraform` looks like this:

1. From the directory in which you executed `terraform init` and `terraform apply` execute `terraform destroy`:

    ```bash
    terraform destroy
    ```

1. You'll be prompted for a subscription ID. Supply the subscription ID you want to used previously:

    ```plaintext
    > terraform destroy
    var.hub_subid
    Subscription ID for the deployment

    Enter a value: 
    ```

1. Terraform will then inspect the state of your Azure environment and compare it with what is described in Terraform state. Eventually, you'll be prompted for your approval to destroy resources. Supply `yes`:

    ```plaintext
    Do you want to perform these actions?
      Terraform will perform the actions described above.
      Only 'yes' will be accepted to approve.

    Enter a value: yes
    ```

This command will attempt to remove all the resources that were created by `terraform apply` and could take up to 45 minutes.

## Development Setup

For development of the Mission Landing Zone Starter Terraform templates we recommend using the development container because it has the necessary dependencies already installed. To get started follow the [guidance for using the development container](../.devcontainer/README.md).

## See Also

[Terraform](https://www.terraform.io/)

[Terraform Tutorial](https://learn.hashicorp.com/collections/terraform/azure-get-started/)

[Developing in a container](https://code.visualstudio.com/docs/remote/containers) using Visual Studio Code
