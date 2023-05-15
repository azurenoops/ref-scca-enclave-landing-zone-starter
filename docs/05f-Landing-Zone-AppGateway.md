# Create Azure Application Gateway with WAF

The following will be created:
* Resource Group for Azure Application gateway (main.tf)
* Azure Application Gateway (App_Gateway.tf)

**Note**: You will need a TLS/SSL Certificate with the Private Key (PFX Format) for the Application Gateway Listener. The PFX certificate on the listener needs the entire certificate chain and the password must be 4 to 12 characters. For the purpose of this quickstart, you can use a [Self Signed Certificate](https://learn.microsoft.com/EN-us/azure/application-gateway/create-ssl-portal#create-a-self-signed-certificate) or one issued from an internal Certificate Authority. Copy the PFX file to the /Scenarios/ASA-Secure-Baseline-/Terraform/07-LZ-AppGateway folder.

Review and if needed, comment out and modify the variables within the "05f Application Gateway" section of the common variable definitons file [parameters.tfvars](./parameters.tfvars). 

Sample:

```bash
##################################################
# 05f Application Gateway
##################################################

    # azure_app_gateway_zones        = [1,2,3]
    # backendPoolFQDN                = "default-replace-me.private.azuremicroservices.io"
    # certfilename                   = "mycertificate.pfx"
    
```

After Modifying the variables, move on to deploying the Shared Services.

### Next step

:arrow_forward: [Deploy the Shared Services](./Shared-Services.md)