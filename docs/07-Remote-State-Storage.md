# Use the Azure CLI to create a storage account to store the Terraform state files for Mission Enclave Landing Zone Starter

This storage account will be used to store the state of each deployment step and will be accessed by Terraform to reference values stored in the various deployment state files.

## Overview

For simple test scripts or for development, a local state file will work. However, if we are working in a team, deploying our infrastructure from a CI/CD tool or developing a Terraform using multiple layers, we need to store the state file in a remote backend and lock the file to avoid mistakes or damage the existing infrastructure.

We can use remote backends, such as Azure Storage to keep our files safe and share between multiple users.

## Creating a Service Principal and a Client Secret

Using a Service Principal, also known as SPN, is a best practice for DevOps or CI/CD environments and is one of the most popular ways to set up a remote backend and later move to CI/CD, such as Azure DevOps.

First, we need to authenticate to Azure. To authenticate using Azure CLI, we type:

```bash
az login
```

The process will launch the browser and after the authentication is complete we are ready to go.

We will use the following command to get the list of Azure subscriptions:

```bash
az account list --output table
```

We can select the subscription using the following command (both subscription id and subscription name are accepted):

```bash
az account set --subscription <Azure-SubscriptionId>
```

Then create the service principal account using the following command:

We need to create a service principal and a client secret to access the remote backend. We can use the Azure CLI to create the service principal and the client secret.

```bash
az ad sp create-for-rbac --name "terraform" --role contributor --scopes /subscriptions/<subscription_id> --sdk-auth
```
These values will be mapped to these Terraform variables:

- appId (Azure) → client_id (Terraform).
- password (Azure) → client_secret (Terraform).
- tenant (Azure) → tenant_id (Terraform).

## Configuring the Remote Backend to use Azure Storage with Terraform (Preferred Method)

Before we can deploy the reference implementation, we will need to create the storage account in Azure Storage using Terraform. This will have to be done manually using the Azure Portal or using the Azure CLI. We will use the Azure CLI to create the storage account and the container.

We will start using a files called az-remote-backend-*.tf located in [01-remote-backend](../infrastructure/terraform/modules/01-remote-state/) to create the storage account and the container.

## Configuring the Remote Backend to use Azure Storage in Azure CLI

We need to create a storage account and a container to store the Terraform state file. We can use the Azure CLI to create the storage account and the container.

```bash
az storage account create --name <storage-account-name> --resource-group <resource-group-name> --sku Standard_LRS --encryption-services blob
```

```bash
az storage container create --name <container-name> --account-name <storage-account-name>
```

or

You can use the bash script ["az-remote-backend.sh"](../src/modules/network_artifacts/remote-backend/az-remote-backend.sh) to create the storage account and the container.

## Authenticating to Azure using a Service Principal (SPN) to use State Files in Remote Backend

If we want to use shared state files in a remote backend with SPN, we can configure Terraform using the following procedure:

We will create a configuration file with the credentials information. For this example, I called the file azurecreds.conf. This is the content of the file:

```bash
ARM_SUBSCRIPTION_ID="0000000-0000-0000-0000-000000000000"
ARM_CLIENT_ID = "0000000-0000-0000-0000-000000000000"
ARM_CLIENT_SECRET="0000000-0000-0000-0000-000000000000"
ARM_TENANT_ID="0000000-0000-0000-0000-000000000000"
```
then we create the file versions.tf and add the code to manage the Terraform and the Azure providers:

```hcl
# Define Terraform provider
terraform {
  required_version = ">= 0.12"
  backend "azurerm" {
    resource_group_name  = "me-tfstate-rg"
    storage_account_name = "metfstate"
    container_name       = "core-tfstate"
    key                  = "core.me.tfstate"
  }
}
# Configure the Azure provider
provider "azurerm" { 
  environment = "public"
}
```

Finally, we initialize the Terraform configuration using this command:

```hcl
terraform init -backend-config=backend.conf
```

Then, we launch the stack as usual:

```hcl
terraform apply -auto-approve
```

## Configure Variables for state management

Modify the variables within the "01 Remote Storage State configuration" section of the variable definitions file [parameters.tfvars](./parameters.tfvars).

Sample: 

```bash

#########################################
## Remote Storage State configuration  ##
#########################################

# Deployment state storage information
    state_sa_name  = "xxxx-enter-the-storage-account-name-xxxx"
    state_sa_rg    = "xxxx-enter-the-resource-group-here-xxxx"
    state_sa_container_name = "anoastatesa"


```
