# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

locals {
  #filter the location output for the current region, virtual machine resources, and filter out entries that don't include the capabilities list
  location_valid_vms = [
    for location in jsondecode(data.azapi_resource_list.example.output).value : location
    if contains(location.locations, var.deployment_region) && #if the sku location field matches the selected location
    length(location.restrictions) < 1 &&                      #and there are no restrictions on deploying the sku (i.e. allowed for deployment)
    location.resourceType == "virtualMachines" &&             #and the sku is a virtual machine
    !strcontains(location.name, "C") &&                       #no confidential vm skus
    !strcontains(location.name, "B") &&                       #no B skus
    length(try(location.capabilities, [])) > 1                #avoid skus where the capabilities list isn't defined
  ]

  #filter the region virtual machines by desired capabilities (v1/v2 support, 2 cpu, and encryption at host)
  deploy_skus = [
    for sku in local.location_valid_vms : sku
    if length([
      for capability in sku.capabilities : capability
      if(capability.name == "HyperVGenerations" && capability.value == "V1,V2") ||
      (capability.name == "vCPUs" && capability.value == "2") ||
      (capability.name == "EncryptionAtHostSupported" && capability.value == "True") ||
      (capability.name == "CpuArchitectureType" && capability.value == "x64")
    ]) == 4
  ]
}