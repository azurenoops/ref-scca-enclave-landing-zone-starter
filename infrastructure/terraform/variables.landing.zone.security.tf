# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

/*
  PARAMETERS
  Here are all the variables a user can override.
*/

################################
# Landing Zone Configuration  ##
################################

###############
# Security  ###
###############

variable "security_name" {
  description = "A name for the security. It defaults to security."
  type        = string
  default     = "security"
}

variable "security_vnet_address_space" {
  description = "The address space of the security virtual network."
  type        = list(string)
  default     = ["10.8.6.0/26"]
}

variable "security_subnets" {
  description = "The subnets of the security virtual network."
  default     = {}
}

variable "enable_forced_tunneling_on_security_route_table" {
  description = "Enables forced tunneling on the security route table."
  type        = bool
  default     = true
}
