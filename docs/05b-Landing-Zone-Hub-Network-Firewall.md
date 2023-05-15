# Deploy the Landing Zone - Azure Firewall Resource

The following will be created:

* Azure Firewall (main.tf)
* Required Firewall rules (main.tf)

Review and if needed, comment out and modify the variables within the "04 Landing Zone Configuration" section under "Management Hub Firewall" of the common variable definitons file [parameters.tfvars](./tfvars/parameters.tfvars). Do not modify if you plan to use the default values.

Sample:

```bash

###################################
# 04 Landing Zone Configuration  ##
###################################

#############################
# Management Hub Firewall ###
#############################

# Firewall Settings
# By default, Azure NoOps will create Azure Firewall in Hub VNet. 
# If you do not want to create Azure Firewall, 
# set enable_firewall to false. This will allow different firewall products to be used (Example: F5).  
enable_firewall = true

# By default, forced tunneling is enabled for Azure Firewall.
# If you do not want to enable forced tunneling, 
# set enable_forced_tunneling to false.
enable_forced_tunneling = true


# (Optional) To enable the availability zones for firewall. 
# Availability Zones can only be configured during deployment 
# You can't modify an existing firewall to include Availability Zones
firewall_zones = [1, 2, 3]

# # (Optional) specify the Network rules for Azure Firewall l
# This is default values, do not need this if keeping default values
firewall_network_rules = [
  {
    name     = "AllowAzureCloud"
    priority = "100"
    action   = "Allow"
    rules = [
      {
        name                  = "AzureCloud"
        protocols             = ["Any"]
        source_addresses      = ["*"]
        destination_addresses = ["AzureCloud"]
        destination_ports     = ["*"]
      }
    ]
  },
  {
    name     = "AllowTrafficBetweenSpokes"
    priority = "200"
    action   = "Allow"
    rules = [
      {
        name                  = "AllSpokeTraffic"
        protocols             = ["Any"]
        source_addresses      = ["10.96.0.0/19"]
        destination_addresses = ["*"]
        destination_ports     = ["*"]
      }
    ]
  }
]

# (Optional) specify the application rules for Azure Firewall
# This is default values, do not need this if keeping default values
firewall_application_rules = [
  {
    name     = "AzureAuth"
    priority = "110"
    action   = "Allow"
    rules = [
      {
        name              = "msftauth"
        source_addresses  = ["*"]
        destination_fqdns = ["aadcdn.msftauth.net", "aadcdn.msauth.net"]
        protocols = {
          type = "Https"
          port = 443
        }
      }
    ]
  }
]

```

After Modifying the variables, move on to Bastion/DNS Zones.

### Next step

:arrow_forward: [Deploy the Spoke/LZ Virtual Network](./05b-Landing-Zone-Hub-Network-Bastion.md)
