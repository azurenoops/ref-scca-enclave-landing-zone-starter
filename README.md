# Create a SCCA compliant Mission Enclave with an web app service and sql db workload using Terraform and GitHub #

This reference implementation shows how to create a [SCCA Compliant Mission Enclave](https://docs.microsoft.com/en-us/azure) with an web app and sql db workload using:

- [Terraform](https://www.terraform.io/intro/index.html) as infrastructure as code (IaC) tool to build, change, and version the infrastructure on Azure in a safe, repeatable, and efficient way.
- [Github Actions](https://docs.github.com/en/actions/learn-github-actions/understanding-github-actions) is a continuous integration and continuous delivery (CI/CD) platform that allows you to automate your build, test, and deployment pipeline.Use these pipelines to automate the deployment and undeployment of the entire infrastructure on multiple environments on the Azure platform.

In a SCCA Compliant Mission Enclave, the private network is not exposed via to the internet. Hence, to manage any managed services such as an web app, you will need to use a virtual machine that has access to the WebApp's Azure Virtual Network (VNet).

> **NOTE**
> This reference implementation deploys a jumpbox virtual machine in the shared services virtual network peered with the virtual network that hosts the WebApp. There are several options for establishing network connectivity to the WebApp.

## Architecture ##

The following picture shows the high-level architecture created by the Terraform modules included in this reference implementation:

![Architecture](./docs/images/normalized-architecture.png)

The architecture is composed of the following elements:

- A hub virtual network with three subnets:
  - AzureBastionSubnet used by Azure Bastion
  - AzureFirewallSubnet used by Azure Firewall
  - AzureManagementFirewallSubnet used by Azure Firewall
- A Operations virtual network
- A shared services virtual network with two subnets:
  - VmSubnet used by the jumpbox virtual machine and private endpoints
- An Azure Firewall used to control the egress traffic from the private web app. For more information on how to lock down your private web app and filter outbound traffic, see: 
  - [Control egress traffic for cluster nodes in Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/limit-egress-traffic)
- An Azure Bastion resource that provides secure and seamless SSH connectivity to the Vm virtual machine directly in the Azure portal over SSL
- A jumpbox virtual machine used to manage the Azure Web App Service
- A Private DNS Zone for the name resolution of each private endpoint.
- A Virtual Network Link between each Private DNS Zone and both the hub and spoke virtual networks
- A Log Analytics workspace to collect the diagnostics logs and metrics of both the Web App Service and Vm virtual machine.

## Importance of Separation of Duties (Azure NoOps Shared Responsibility Model) ##

In this is a reference implementation, the repo is self contained and contains all the Terraform modules and configuration files to deploy the infrastructure on Azure. This does not take into account of roles. Azure NoOps Shared Responsibility Model pushes the need to seperate roles. In a production environment, you will need to separate the Terraform modules and configuration files into different repositories. For example, you can have the following repositories:

- A repository for the Management Layer Terraform modules (includes management groups, management service such as budgets, landing zones, and shared services)
- A repository for the Management Policy Terraform modules
- A repository for the Workload Terraform modules (includes workload spoke and workload services such as web app, and Azure SQL Database)

The following picture shows the separation of duties for the Terraform modules and configuration files:

![Separation of Duties](./docs/images/separation-of-duties.png)

It is important to understand how you would set this up for a production environment. The separation of duties is important to ensure that the Terraform modules can be reused across multiple environments and aloows the right role to control changes.

## Policy ##

Policy is a important piece of an Mission Enclave and required for a ATO to your environment. It is too broad of a topic to add to this reference implementation.

If you are interested in learning more about how to apply policy to use in an Mission Enclave, you can use the following resources:

- [Azure NoOps Policy Starter](https://github.com) (Coming Soon)

However, you can use the following resources to learn more about policy in general:

- [Azure Policy](https://docs.microsoft.com/en-us/azure/governance/policy/overview)

## Limitations ##

## Requirements ##

There are some requirements you need to complete before we can deploy Terraform modules using Github or Azure DevOps.

- Store the Terraform state file to an Azure storage account. For more information on how to create to use a storage account to store remote Terraform state, state locking, and encryption at rest, see [Store Terraform state in Azure Storage](https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli)

### GitHub

- Create an GitHub Project. For more information, see [Create a project in GitHub](https://docs.github.com/en/issues/planning-and-tracking-with-projects/creating-projects/creating-a-project)
- Create an [GitHub Secrets](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-portal%2Cwindows) to your Azure subscription.

## Terraform State ##

In order to deploy Terraform modules to Azure you can use Github Actions or Azure DevOps CI/CD pipelines. [Azure DevOps](https://docs.microsoft.com/en-us/azure/devops/user-guide/what-is-azure-devops?view=azure-devops) provides developer services for support teams to plan work, collaborate on code development, and build and deploy applications and infrastructure components using IaC technologies such as ARM Templates, Bicep, and Terraform.

Terraform stores [state](https://www.terraform.io/docs/language/state/index.html) about your managed infrastructure and configuration in a special file called state file. This state is used by Terraform to map real-world resources to your configuration, keep track of metadata, and to improve performance for large infrastructures. Terraform state is used to reconcile deployed resources with Terraform configurations. When using Terraform to deploy Azure resources, the state allows Terraform to know what Azure resources to add, update, or delete. By default, Terraform state is stored in a local file named "terraform.tfstate", but it can also be stored remotely, which works better in a team environment. Storing the state in a local file isn't ideal for the following reasons:

- Storing the Terraform state in a local file doesn't work well in a team or collaborative environment.
- Terraform state can include sensitive information.
- Storing state locally increases the chance of inadvertent deletion.

Each Terraform configuration can specify a [backend](https://www.terraform.io/docs/language/settings/backends/index.html), which defines where and how operations are performed, where [state](https://www.terraform.io/docs/language/state/index.html) snapshots are stored. The [Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) or **azurerm** can be used to configure infrastructure in Microsoft Azure using the Azure Resource Manager API's. Terraform provides a [backend](https://www.terraform.io/docs/language/settings/backends/azurerm.html) for the Azure Provider that allows to store the state as a Blob with the given Key within a given Blob Container inside a Blob Storage Account. This backend also supports state locking and consistency checking via native capabilities of the Azure Blob Storage. [](https://www.terraform.io/docs/language/settings/backends/azurerm.html) When using Azure DevOps to deploy services to a cloud environment, you should use this backend to store the state to a remote storage account. For more information on how to create to use a storage account to store remote Terraform state, state locking, and encryption at rest, see [Store Terraform state in Azure Storage](https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli). Under the [storage-account](./storage-account) folder in this reference implementation, you can find a Terraform module and bash script to deploy an Azure storage account where you can persist the Terraform state as a blob.

## Next Steps to implement Mission Enclave Starter

Pick the below scenario to get started on a reference implementation. This implementation has a detailed README.md that will walk you through the deployment steps.

:arrow_forward: [Mission Enclave Starter](/infrastructure/README.md)

Deployment Details:
| Deployment Methodology | GitHub Actions | Azure DevOps |
|--------------|--------------|--------------|
|Terraform|[Published](./docs/11-e2e-githubaction.md)| Coming soon |

## Got feedback

Please leverage issues if you have any feedback or request on how we can improve on this repository.

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkId=521839>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

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

## Legal Notices

Microsoft and any contributors grant you a license to the Microsoft documentation and other content
in this repository under the [Creative Commons Attribution 4.0 International Public License](https://creativecommons.org/licenses/by/4.0/legalcode),
see the [LICENSE](LICENSE) file, and grant you a license to any code in the repository under the [MIT License](https://opensource.org/licenses/MIT), see the
[LICENSE-CODE](LICENSE-CODE) file.

Microsoft, Windows, Microsoft Azure and/or other Microsoft products and services referenced in the documentation
may be either trademarks or registered trademarks of Microsoft in the United States and/or other countries.
The licenses for this project do not grant you rights to use any Microsoft names, logos, or trademarks.
Microsoft's general trademark guidelines can be found at http://go.microsoft.com/fwlink/?LinkID=254653.

Privacy information can be found at https://privacy.microsoft.com/en-us/

Microsoft and any contributors reserve all other rights, whether under their respective copyrights, patents,
or trademarks, whether by implication, estoppel or otherwise.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft
trademarks or logos is subject to and must follow
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.
