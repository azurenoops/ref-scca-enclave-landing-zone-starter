# SCCA compliant Mission Enclave with an web app service workload

This reference implementation can be used for experimenting with web app service workloads in a typical SCCA compliant landing zone design for a regulated organizations. It uses a hub and spoke architecture with a two spokes. East/West traffic (traffic between resources in the hub and resources in the spoke) is filtered with Network Security Groups and an Azure Firewall is used for controlling outbound traffic to the internet. An Azure Application Gateway with Web Application Firewall is used to protect inbound HTTP/s connections to web app service workloads from the internet. 

![Architectural diagram for the Mission Enclave.](../docse/images/anoa-mission-enclave-web-app.jpg)

## Core architecture components

* Azure Web App Service
* Azure Virtual Networks (hub-spoke)
* Azure Bastion
* Azure Firewall
* Azure Application Gateway with WAF (optional)
* Azure Key vault
* Azure Private DNS Zones
* Log Analytics Workspace
* Application Insights

## Next

Pick one of the IaC options below and follow the instructions to deploy the Azure Spring Apps reference implementation.

:arrow_forward: [Terraform](./infrastructure/Terraform)

:arrow_forward: [Bicep](./infrastructure/Bicep) (coming soon)
