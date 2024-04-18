# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

resource "random_integer" "deploy_sku" {
  min = 0
  max = length(local.deploy_skus) - 1
}