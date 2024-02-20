# Workflows

These are the automated workflows we use for ensuring a quality working product.

For more on GitHub Actions: <https://docs.github.com/en/actions/>

For more on workflows: <https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions/>

## Contents

- create_plan.yml

    This workflow assumes some pre-requisites have been set-up. See: [Configuration Prerequisites](#configuration-prerequisites)

    1. Authenticates against a pre-configured storage account that contains
        - values for authenticating against a storage account
        - values for deploying terraform

- apply_plan.yml

    This workflow assumes some pre-requisites have been set-up. See: [Configuration Prerequisites](#configuration-prerequisites)

    1. Authenticates against a pre-configured storage account that contains
        - values for authenticating against a storage account
        - values for deploying terraform

    1. Pulls known good MELZ and Terraform configuration variables from that storage account

    1. Applies terraform anew from that configuration (see [build/README.md](../../build/README.md) for how this works)

- check_for_drift.yml

    1. Checks for drift in the infrastructure/terraform directory

- destroy_plan.yml

    1. Destroys the terraform configuration

- validate_plan.yml

    1. Recursively validates and lints all the terraform referenced at infrastructure/terraform

## Configuration Prerequisites

1. Configuration store

    When applying terraform locally or from this automation, an MELZ Configuration file (commonly mlz.config) and Terraform-specific variables files (commonly *.tfvars) are required.

- deploy_dependencies.yml

    1. Builds and deploys the dependencies for the terraform configuration