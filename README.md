# Create a SCCA compliant Mission Enclave with an web app service workload using Terraform and GitHub #

This reference implementation shows how to create a [Mission Enclave](https://docs.microsoft.com/en-us/azure) with an web app workload using:

- [Terraform](https://www.terraform.io/intro/index.html) as infrastructure as code (IaC) tool to build, change, and version the infrastructure on Azure in a safe, repeatable, and efficient way.
- [Github Actions or Azure DevOps Pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops) to automate the deployment and undeployment of the entire infrastructure on multiple environments on the Azure platform.

In a Mission Enclave, the private network is not exposed via to the internet. Hence, to manage any managed services such as an web app, you will need to use a virtual machine that has access to the WebApp's Azure Virtual Network (VNet). This reference implementation deploys a jumpbox virtual machine in the hub virtual network peered with the virtual network that hosts the WebApp. There are several options for establishing network connectivity to the WebApp.

- Create a virtual machine in the same Azure Virtual Network (VNet) as the WebApp.
- Use a virtual machine in a separate network and set up Virtual network peering. See the section below for more information on this option.
- Use an Express Route or VPN connection.

Creating a virtual machine in the same virtual network as the WebApp or in a peered virtual network is the easiest option. Express Route and VPNs add costs and require additional networking complexity. Virtual network peering requires you to plan your network CIDR ranges to ensure there are no overlapping ranges. For more information on Azure Private Links, see [What is Azure Private Link?](https://docs.microsoft.com/en-us/azure/private-link/private-link-overview)

In addition, the reference implementation creates a private endpoint to access all the managed services deployed by the Terraform modules via a private IP address:

- Azure Storage Account
- Azure Key Vault

> **NOTE**  
> If you want to deploy a web app in a private network, you can use the [Azure Private Link](https://docs.microsoft.com/en-us/azure/private-link/private-link-overview) service to access the web app. For more information, see [Tutorial: Create and configure an Azure Private Link service using the Azure portal](https://docs.microsoft.com/en-us/azure/private-link/create-private-link-service-portal).

## Architecture ##

The following picture shows the high-level architecture created by the Terraform modules included in this reference implementation:

![Architecture](./docs/images/normalized-architecture.png)

The following picture provides a more detailed view of the infrastructure on Azure.

![Architecture](./docs/images/overall-architecture.png)

The architecture is composed of the following elements:

## Limitations ##

## Requirements ##

There are some requirements you need to complete before we can deploy Terraform modules using Github or Azure DevOps.

- Store the Terraform state file to an Azure storage account. For more information on how to create to use a storage account to store remote Terraform state, state locking, and encryption at rest, see [Store Terraform state in Azure Storage](https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli)
- Create an Azure DevOps Project. For more information, see [Create a project in Azure DevOps](https://docs.microsoft.com/en-us/azure/devops/organizations/projects/create-project?view=azure-devops&tabs=preview-page)
- Create an [Azure DevOps Service Connection](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml) to your Azure subscription. No matter you use Service Principal Authentication (SPA) or an Azure-Managed Service Identity when creating the service connection, make sure that the service principal or managed identity used by Azure DevOps to connect to your Azure subscription is assigned the owner role on the entire subscription.

## Terraform State ##

In order to deploy Terraform modules to Azure you can use Github Actions or Azure DevOps CI/CD pipelines. [Azure DevOps](https://docs.microsoft.com/en-us/azure/devops/user-guide/what-is-azure-devops?view=azure-devops) provides developer services for support teams to plan work, collaborate on code development, and build and deploy applications and infrastructure components using IaC technologies such as ARM Templates, Bicep, and Terraform.

Terraform stores [state](https://www.terraform.io/docs/language/state/index.html) about your managed infrastructure and configuration in a special file called state file. This state is used by Terraform to map real-world resources to your configuration, keep track of metadata, and to improve performance for large infrastructures. Terraform state is used to reconcile deployed resources with Terraform configurations. When using Terraform to deploy Azure resources, the state allows Terraform to know what Azure resources to add, update, or delete. By default, Terraform state is stored in a local file named "terraform.tfstate", but it can also be stored remotely, which works better in a team environment. Storing the state in a local file isn't ideal for the following reasons:

- Storing the Terraform state in a local file doesn't work well in a team or collaborative environment.
- Terraform state can include sensitive information.
- Storing state locally increases the chance of inadvertent deletion.

Each Terraform configuration can specify a [backend](https://www.terraform.io/docs/language/settings/backends/index.html), which defines where and how operations are performed, where [state](https://www.terraform.io/docs/language/state/index.html) snapshots are stored. The [Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) or **azurerm** can be used to configure infrastructure in Microsoft Azure using the Azure Resource Manager API's. Terraform provides a [backend](https://www.terraform.io/docs/language/settings/backends/azurerm.html) for the Azure Provider that allows to store the state as a Blob with the given Key within a given Blob Container inside a Blob Storage Account. This backend also supports state locking and consistency checking via native capabilities of the Azure Blob Storage. [](https://www.terraform.io/docs/language/settings/backends/azurerm.html) When using Azure DevOps to deploy services to a cloud environment, you should use this backend to store the state to a remote storage account. For more information on how to create to use a storage account to store remote Terraform state, state locking, and encryption at rest, see [Store Terraform state in Azure Storage](https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli). Under the [storage-account](./storage-account) folder in this reference implementation, you can find a Terraform module and bash script to deploy an Azure storage account where you can persist the Terraform state as a blob.

## Next Steps to implement Mission Enclave Starter

Pick the below scenario to get started on a reference implementation. Each scenario has a detailed README.md that will walk you through the deployment steps.

:arrow_forward: [Baseline](/infrastructure/README.md)

Deployment Details:
| Deployment Methodology | GitHub Actions | Azure DevOps |
|--------------|--------------|--------------|
|Terraform|[Published](./docs/Terraform/e2e-githubaction.md)| Coming soon |
|Bicep|Coming soon| Coming soon |

## Got a feedback

Please leverage issues if you have any feedback or request on how we can improve on this repository.

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at https://go.microsoft.com/fwlink/?LinkId=521839. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft 
trademarks or logos is subject to and must follow 
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.