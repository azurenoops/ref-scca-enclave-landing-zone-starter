# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
  DATA
  Here are all the data sources used in the landing zone.
*/

### this segment of code gets valid vm skus for deployment in the current subscription
data "azurerm_subscription" "current" {
}

#get the full sku list (azapi doesn't currently have a good way to filter the api call)
data "azapi_resource_list" "example" {
  type                   = "Microsoft.Compute/skus@2021-07-01"
  parent_id              = data.azurerm_subscription.current.id
  response_export_values = ["*"]
}