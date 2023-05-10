# Deploying the Mission Enclave with Web App Service workload E2E using GitHub Actions

To deploy the Mission Enclave with Web App Service workload, we'll setup a GitHub Actions CI/CD workflow that will build and deploy our application whenever we push new commits to the main branch of our repository.

## What's CI/CD?

CI/CD stands for _Continuous Integration_ and _Continuous Delivery_.

Continuous Integration is a software development practice that requires developers to integrate code into a shared repository several times a day.
Each integration can then be verified by an automated build and automated tests.
By doing so, you can detect errors quickly, and locate them more easily.

Continuous Delivery pushes this practice further, by preparing for a release to production after each successful build.
By doing so, you can get working software into the hands of users faster.

## What's GitHub Actions?

[GitHub Actions](https://github.com/features/actions) is a service that lets you automate your software development workflows.
It allows you to run workflows that can be triggered by any event on the GitHub platform, such as opening a pull request or pushing a commit to a repository.

It's a great way to automate your CI/CD pipelines, and it's free for public repositories.

## Setting Up GitHub Actions for deployment

To set up GitHub Actions for deployment, we'll need to use the new workflow file in our repository.
This file will contain the instructions for our CI/CD pipeline.

## Setup secrets

We are using different secrets in our workflow: <insert secrets>. Secrets in GitHub are encrypted and allow you to store sensitive information such as passwords or API keys, and use them in your workflows using the ${{ secrets.MY_SECRET }} syntax.

In GitHub, secrets can be defined at three different levels:

* Repository level: secrets defined at the repository level are available in all workflows of the repository.

* Organization level: secrets defined at the organization level are available in all workflows of the GitHub organization.

* Environment level: secrets defined at the environment level are available only in workflows referencing the specified environment.

For this workshop, we’ll define our secrets at the repository level. To do so, go to the Settings tab of your repository, and select Secrets then Actions under it, in the left menu.

Then select New repository secret and create secrets for <insert secrets>.

## [!TIP]

You can also use the <https://cli.github.com[GitHub> CLI] to define your secrets, using the command `gh secret set <MY_SECRET> -b"<SECRET_VALUE>" -R <repository_url>`

## Creating an Azure Service Principal

In order to deploy our Mission Enclave with Web App Service workload, we'll need to create an Azure Service Principal.
This is an identity that can be used to authenticate to Azure, and that can be granted access to specific resources.

To create a new Service Principal, run the following commands:

```bash
    SUBSCRIPTION_ID=$(
      az account show \
        --query id \
        --output tsv \
        --only-show-errors
    )

    AZURE_CREDENTIALS=$(
      MSYS_NO_PATHCONV=1 az ad sp create-for-rbac \
        --name="sp-${PROJECT}-${UNIQUE_IDENTIFIER}" \
        --role="Contributor" \
        --scopes="/subscriptions/$SUBSCRIPTION_ID" \
        --sdk-auth \
        --only-show-errors
    )

    echo $AZURE_CREDENTIALS
    echo $SUBSCRIPTION_ID     
```

Then just like in the previous step, create a new secret in your repository named `AZURE_SUBSCRIPTION_ID`, `AZURE_CLIENT_ID`, `AZURE_CLIENT_SECRET`, `AZURE_TENANT_ID`. You can copy paste these values from the AZURE_CREDENTIALS value returned in the cli. Also create another secret for  `AZURE_CREDENTIALS` and paste the value of the `AZURE_CREDENTIALS` variable as the secret value (make sure to _copy the entire JSon_).

![GitHub Secrets](../../../images/github_anoa_secrets.png)

<TODO: finish doc>