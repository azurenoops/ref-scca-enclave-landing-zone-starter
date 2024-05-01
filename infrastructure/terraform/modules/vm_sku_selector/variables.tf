# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

variable "deployment_region" {
  type        = string
  description = "The selected region for deployment"
}

variable "environment" {
  type        = string
  description = "The environment to deploy to"
  default     = "public"  
}