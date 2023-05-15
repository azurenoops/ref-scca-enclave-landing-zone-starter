# Deploy the Landing Zone - Management Hub Virtual Network

The following will be created:

* Resource Group for Management Hub Networking (main.tf)
* Management Hub Network (main.tf)
* Management Hub Subnets (main.tf)

Review and if needed, comment out and modify the variables within the "04 Landing Zone Configuration" section under "Management Hub Virtual Network" of the common variable definitons file [parameters.tfvars](./tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Sample:

```bash

###################################
# 04 Landing Zone Configuration  ##
###################################

####################################
# Management Hub Virtual Network ###
####################################

# (Required)  Hub Virtual Network Parameters   
# Provide valid VNet Address space and specify valid domain name for Private DNS Zone.  
hub_vnet_address_space              = ["10.8.4.0/23"]   # (Required)  Hub Virtual Network Parameters  
fw_client_snet_address_prefixes     = ["10.8.4.64/26"]  # (Required)  Hub Firewall Subnet Parameters  
ampls_subnet_address_prefixes       = ["10.8.5.160/27"]   # (Required)  AMPLS Subnet Parameter
fw_management_snet_address_prefixes = ["10.8.4.128/26"] # (Optional)  Hub Firewall Management Subnet Parameters. If not provided, force_tunneling is not needed.
gateway_vnet_address_space          = ["10.8.4.0/27"]   # (Optional)  Hub Gateway Subnet Parameters

# (Required) Hub Subnets 
# Default Subnets, Service Endpoints
# This is the default subnet with required configuration, check README.md for more details
# First address ranges from VNet Address space reserved for Firewall Subnets. 
# First three address ranges from VNet Address space reserved for Gateway, AMPLS And Firewall Subnets. 
# These are default subnets with required configuration, check README.md for more details
# NSG association to be added automatically for all subnets listed here.
# subnet name will be set as per Azure naming convention by defaut. expected value here is: <App or project name>
hub_subnets = {
  default = {
    name                                       = "hub-core"
    address_prefixes                           = ["10.8.4.224/27"]
    service_endpoints                          = ["Microsoft.Storage"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true
  }

  dmz = {
    name                                       = "app-gateway"
    address_prefixes                           = ["10.8.5.64/27"]
    service_endpoints                          = ["Microsoft.Storage"]
    private_endpoint_network_policies_enabled  = false
    private_endpoint_service_endpoints_enabled = true
    nsg_subnet_inbound_rules = [
      # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
      # To use defaults, use "" without adding any value and to use this subnet as a source or destination prefix.
      # 65200-65335 port to be opened if you planning to create application gateway
      ["http", "100", "Inbound", "Allow", "Tcp", "80", "*", ["0.0.0.0/0"]],
      ["https", "200", "Inbound", "Allow", "Tcp", "443", "*", [""]],
      ["appgwports", "300", "Inbound", "Allow", "Tcp", "65200-65335", "*", [""]],

    ]
    nsg_subnet_outbound_rules = [
      # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
      # To use defaults, use "" without adding any value and to use this subnet as a source or destination prefix.
      ["ntp_out", "400", "Outbound", "Allow", "Udp", "123", "", ["0.0.0.0/0"]],
    ]
  }
}

```

After Modifying the variables, move on to Management Hub OperationL Logging.

### Next step

:arrow_forward: [Deploy the Landing Zone - Management Hub OperationL Logging](./05a-Landing-Zone-Hub-Logging.md)
