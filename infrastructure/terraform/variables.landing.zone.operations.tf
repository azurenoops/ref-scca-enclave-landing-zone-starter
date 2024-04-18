# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
  PARAMETERS
  Here are all the variables a user can override.
*/

################################
# Landing Zone Configuration  ##
################################

#################
# Operations  ###
#################

variable "ops_name" {
  description = "A name for the ops. It defaults to ops."
  type        = string
  default     = "ops"
}

variable "ops_vnet_address_space" {
  description = "The address space of the operations virtual network."
  type        = list(string)
  default     = ["10.8.6.0/26"]
}

variable "ops_subnets" {
  description = "The subnets of the operations virtual network."
  default     = {}
}

variable "enable_forced_tunneling_on_ops_route_table" {
  description = "Enables forced tunneling on the operations route table."
  type        = bool
  default     = true
}
