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

>NOTE: Since this reference implementation is designed to use remote state, you will need to comment out the [`backend "local" {}` block in the versions.tf](./../infrastructure/terraform/versions.tf) file. This will allow you to deploy the landing zone without having to deploy the remote state storage account first.

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
`subscription_id_identity` | value of hub_subid | Subscription ID for identity tier
`subscription_id_operations` | value of hub_subid | Subscription ID for operations tier
`subscription_id_devsecops` | value of hub_subid | Subscription ID for devsecops tier

### Mission Enclave Landing Zone Remote State Storage Account

The remote state storage account is used to store the Terraform state files. The state files contain the current state of the infrastructure that has been deployed. The state files are used by Terraform to determine what changes need to be made to the infrastructure when a deployment is run.

To find out more about remote state, see the [Remote State documentation](./07-Remote-State-Storage.md).

### Mission Enclave Landing Zone Global Configuration

The following parameters affect the "01 Global Configuration". To override the defaults edit the variables file at [parameters.tfvars](../infrastructure/terraform/tfvars/parameters.tfvars).

Example Configuration:

Parameter name | Default Value | Description
-------------- | ------------- | -----------
`org_name`       | anoa          | This Prefix will be used on most deployed resources.  10 Characters max.
`deploy_environment` | dev | This Prefix will be used on most deployed resources.  10 Characters max.
`environment` | public | The environment to deploy to.
`default_location` | eastus | The default region to deploy to.
`enable_resource_locks` | false | Enable locks on resources.  true | false
`enable_traffic_analytics` | true | Enable NSG Flow Logs.  true | false

### Mission Enclave Management Groups

The following parameters affect the "02 Management Groups Configuration" To override the defaults edit the variables file at [parameters.tfvars](../infrastructure/terraform/tfvars/parameters.tfvars).

Example Configuration:

Parameter name | Default Value | Description
-------------- | ------------- | -----------
`enable_management_groups` | true | Enable management groups for this subscription
`root_management_group_id` | anoa | The root management group id for this subscription
`root_management_group_display_name` | anoa | The root management group display name for this subscription

To modify the management group structure, go to the [locals.tf](../infrastructure/terraform/locals.tf) file and modify the 'management_groups' section. The 'root_management_group_id' is used for the top level groups.

### Mission Enclave Management Budgets

The following parameter effects budgets. Do not modify if you plan to use the default values.

Example Configuration:

Parameter name | Default Value | Description
-------------- | ------------- | -----------
`enable_management_groups_budgets` | false | enable budgets for management groups
`budget_contact_emails` | ["anoa@contoso.com"] | email addresses to send alerts to for this subscription
`budget_amount` | 100 | budget amount
`budget_start_date`  | 2023-09-01T00:00:00Z | budget start date. format: YYYY-MM-DDTHH:MM:SSZ
`budget_end_date` | 2023-09-01T00:00:00Z | budget end date. format: YYYY-MM-DDTHH:MM:SSZ

### Mission Enclave Management Roles

The following parameter effects custom roles. Do not modify if you plan to use the default values.

Example Configuration:

Parameter name | Default Value | Description
-------------- | ------------- | -----------
`deploy_custom_roles` | true | deploy custom roles

To modify the roles structure, go to the [locals.tf](../infrastructure/terraform/locals.tf) file and modify the 'custom_role_definitions' section.

### Mission Enclave - Management Hub Virtual Network

The following will be created:

- Resource Group for Management Hub Networking (main.tf)
- Management Hub Network (main.tf)
- Management Hub Subnets (main.tf)

Review and if needed, comment out and modify the variables within the "Landing Zone Configuration" section under "Management Hub Virtual Network" of the common variable definitions file [parameters.tfvars](../infrastructure/terraform/tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

>NOTE: IP address ranges are in CIDR notation. For more information, see [Understanding IP Addressing](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-ip-addresses-overview-arm#understanding-ip-addressing-in-your-virtual-network).

Example Configuration:

Parameter name | Default Value | Description
-------------- | ------------- | -----------
`hub_vnet_address_space` | ["10.8.4.0/23"] | The CIDR Virtual Network Address Prefix for the Hub Virtual Network.
`fw_client_snet_address_prefixes` | ["10.8.4.64/26"] | The CIDR Subnet Address Prefix for the Azure Firewall Subnet. It must be in the Hub Virtual Network space. It must be /26.
`ampls_subnet_address_prefixes` | ["10.8.5.160/27"] |  The CIDR Subnet Address Prefix for the Azure Monitor Private Link Subnet. It must be in the Hub Virtual Network space. It must be /27.
`fw_management_snet_address_prefixes` | ["10.8.4.128/26"] |  The CIDR Subnet Address Prefix for the Azure Firewall Management Subnet. It must be in the Hub Virtual Network space. It must be /26.
`gateway_vnet_address_space` | ["10.8.4.0/27"] |  The CIDR Subnet Address Prefix for the Gateway Subnet. It must be in the Hub Virtual Network space. It must be /27. This is the subnet that will be used for the VPN Gateway. Optional, if you do not want to deploy a VPN Gateway, remove this subnet from the list.
`hub_subnets` | array | The subnets to create in the hub virtual network.

### Mission Enclave - Management Hub Operational Logging

The following will be created:

- Log Analytics (main.tf)
- Log Solutions (main.tf)

Review and if needed, comment out and modify the variables within the "Landing Zone Configuration" section under "Management Operational Logging" of the common variable definitions file [parameters.tfvars](../infrastructure/terraform/tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Example Configuration:

Parameter name | Default Value | Description
-------------- | ------------- | -----------
`log_analytics_workspace_sku` | "PerGB2018" | The SKU for the Log Analytics Workspace.  PerGB2018 | Standalone | PerNode | Free | CapacityReservation
`log_analytics_logs_retention_in_days` | 30 | The number of days to retain logs in the Log Analytics Workspace.  30 | 60 | 90 | 120 | 150 | 180 | 365 | 730 | 1827 | 3653
`enable_sentinel` | true | Enable Azure Sentinel.  true | false
`enable_azure_activity_log` | true | Enable Azure Activity Log.  true | false
`enable_vm_insights` | true | Enable Azure Monitor for VMs.  true | false
`enable_azure_security_center` | true | Enable Azure Security Center.  true | false
`enable_container_insights` | true | Enable Azure Monitor for Containers.  true | false
`enable_key_vault_analytics` | true | Enable Azure Monitor for Key Vault.  true | false
`enable_service_map` | true | Enable Azure Monitor for Service Map.  true | false

### Mission Enclave - Azure Firewall Resource

The following will be created:

- Azure Firewall (main.tf)
- Required Firewall rules (main.tf)

Review and if needed, comment out and modify the variables within the "Landing Zone Configuration" section under "Management Hub Firewall" of the common variable definitions file [parameters.tfvars](../infrastructure/terraform/tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Example Configuration:

Parameter name | Default Value | Description
-------------- | ------------- | -----------
`enable_firewall` | true | Enable Azure Firewall.  true | false
`enable_forced_tunneling` | true | Enable forced tunneling.  true | false
`firewall_zones` | array | The availability zones to deploy the firewall to.  1 | 2 | 3
`firewall_network_rules` | array | The network rules to create in the firewall.
`firewall_application_rules` | array | The application rules to create in the firewall.
`firewall_nat_rules` | array | The NAT rules to create in the firewall.

### Mission Enclave - Bastion/Private DNS Zones

The following will be created:

- Azure Bastion (main.tf)
- Private DNS Zones (main.tf)

Review and if needed, comment out and modify the variables within the "Landing Zone Configuration" section under "Bastion/Private DNS Zones" of the common variable definitions file [parameters.tfvars](../infrastructure/terraform/tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Example Configuration:

Parameter name | Default Value | Description
-------------- | ------------- | -----------
`enable_bastion_host` | true | Enable Azure Bastion.  true | false
`azure_bastion_host_sku` | "Standard" | The SKU for the Azure Bastion Host.  Standard | Premium
`azure_bastion_subnet_address_prefix` | ["10.8.4.192/27"] | The CIDR Subnet Address Prefix for the Azure Bastion Subnet. It must be in the Hub Virtual Network space. It must be /27. This is the subnet that will be used for the Azure Bastion Host. Optional, if you do not want to deploy Azure Bastion, remove this subnet from the list.
`hub_private_dns_zones` | array | The private DNS zones to create in the hub virtual network.

### Mission Enclave - Identity Management Spoke Virtual Network

The following will be created:

- Resource Groups for Identity Spoke Networking
- Spoke Networks (Identity)

Review and if needed, comment out and modify the variables within the "Landing Zone Configuration" section under "Identity Management Spoke Virtual Network" of the common variable definitions file [parameters.tfvars](../infrastructure/terraform/tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Example Configuration:

Parameter name | Default Value | Description
-------------- | ------------- | -----------
`id_vnet_address_space` | ["10.8.9.0/24"] | The CIDR Virtual Network Address Prefix for the Identity Virtual Network.
`id_subnets` | array | The subnets to create in the identity virtual network.
`id_private_dns_zones` | array | The private DNS zones to create in the identity virtual network.
`enable_forced_tunneling_on_id_route_table` | true | Enable forced tunneling on the route table.  true | false

### Mission Enclave - Operations Management Spoke Virtual Network

The following will be created:

- Resource Groups for Operations Spoke Networking
- Spoke Networks (Operations)

Review and if needed, comment out and modify the variables within the "Landing Zone Configuration" section under "Operations Management Spoke Virtual Network" of the common variable definitions file [parameters.tfvars](../infrastructure/terraform/tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Example Configuration:

Parameter name | Default Value | Description
-------------- | ------------- | -----------
`ops_vnet_address_space` | ["10.8.6.0/24"] | The CIDR Virtual Network Address Prefix for the Operations Virtual Network.
`ops_subnets` | array | The subnets to create in the operations virtual network.
`ops_private_dns_zones` | array | The private DNS zones to create in the operations virtual network.
`enable_forced_tunneling_on_ops_route_table` | true | Enable forced tunneling on the route table.  true | false

### Mission Enclave - DevSecOps Management Spoke Virtual Network

The following will be created:

- Resource Groups for DevSecOps Spoke Networking
- Spoke Networks (DevSecOps)

Review and if needed, comment out and modify the variables within the "Landing Zone Configuration" section under "DevSecOps Management Spoke Virtual Network" of the common variable definitions file [parameters.tfvars](../infrastructure/terraform/tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Example Configuration:

Parameter name | Default Value | Description
-------------- | ------------- | -----------
`devsecops_vnet_address_space` | ["10.8.7.0/24"] | The CIDR Virtual Network Address Prefix for the DevSecOps Virtual Network.
`devsecops_subnets` | array | The subnets to create in the devsecops virtual network.
`devsecops_private_dns_zones` | array | The private DNS zones to create in the devsecops virtual network.
`enable_forced_tunneling_on_devsecops_route_table` | true | Enable forced tunneling on the route table.  true | false
`use_remote_spoke_gateway` | false | Use a remote spoke gateway.  true | false

### Mission Enclave - DevSecOps Management Spoke Components

The following will be created:

- Resource Groups for DevSecOps Spoke Components
- Spoke Components (DevSecOps)

Review and if needed, comment out and modify the variables within the "Landing Zone Configuration" section under "DevSecOps Management Spoke Components" of the common variable definitions file [parameters.tfvars](../infrastructure/terraform/tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

>NOTE: Key Vault and Bastion Jumpbox are not deployed by default. To deploy them, set the `enable_devsecops_resources` variable to `true`.

Example Configuration:

Parameter name | Default Value | Description
-------------- | ------------- | -----------
`enable_devsecops_resources` | true | Enable DevSecOps resources.  true | false

Example Key Vault Configuration:

Parameter name | Default Value | Description
-------------- | ------------- | -----------
`enabled_for_deployment` | true | Enable DevSecOps resources for deployment.  true | false
`enabled_for_disk_encryption` | true | Enable DevSecOps resources for disk encryption.  true | false
`enabled_for_template_deployment` | true | Enable DevSecOps resources for template deployment.  true | false
`rbac_authorization_enabled` | true | Enable RBAC authorization.  true | false
`enable_key_vault_private_endpoint` | true | Enable Key Vault private endpoint.  true | false
`admin_group_name` | "DevSecOps Admins" | The name of the DevSecOps Admins group for use with Key Vault.

Example Bastion JumpBox Configuration:

Parameter name | Default Value | Description
-------------- | ------------- | -----------
`windows_distribution_name` | "windows2019dc" | The Windows distribution name. View Reference: <https://docs.microsoft.com/en-us/azure/virtual-machines/windows/cli-ps-findimage>
`virtual_machine_size` | "Standard_D2s_v3" | The size of the virtual machine. View Reference: <https://docs.microsoft.com/en-us/azure/virtual-machines/sizes>
`vm_admin_username` | "anoaadmin" | The username for the administrator account for the Bastion VM.
`vm_admin_password` | "Password1234!" | The password for the administrator account for the Bastion VM. This is a secret and used with GitHub Actions. If used for testing, it should be changed after testing.
`nsg_inbound_rules` | array | The inbound rules to create in the NSG for the Bastion VM.
`data_disks` | array | The data disks to create for the Bastion VM.
`deploy_log_analytics_agent` | true | Deploy the Log Analytics agent for the Bastion VM.  true | false

### Mission Enclave - Azure Service Health Configuration

The following will be created:

- Resource Groups for Service Health Configuration
- Service Health Configuration

Review and if needed, comment out and modify the variables within the "Landing Zone Configuration" section under "Azure Service Health Configuration" of the common variable definitions file [parameters.tfvars](../infrastructure/terraform/tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Example Configuration:

Parameter name | Default Value | Description
-------------- | ------------- | -----------
`enable_service_health_monitoring` | true | Enable Service Health Configuration.  true | false
`action_group_short_name` | "anoa" | The short name for the action group.  1-12 characters

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
