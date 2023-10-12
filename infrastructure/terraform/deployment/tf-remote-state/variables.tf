# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Organization name
variable "org_name" {
  type        = string
  description = "Name of the organization. This will be used to name the resources deployed by this module. default is 'anoa'"
  default     = "anoa"
}
# Environment
variable "environment" {
  type        = string
  description = "This variable defines the environment to be built"
  default     = "prod"
}
# Azure region
variable "location" {
  type        = string
  description = "Azure region where resources will be created"
  default     = "eastus"
}
