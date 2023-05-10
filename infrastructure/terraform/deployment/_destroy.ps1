# Destroy in reverse order
$Modules=@()
$Modules+= "app_gateway"
$Modules+= "budgets"
$Modules+= "service_health"
$Modules+= "shared_services"
$Modules+= "landingzone" 
$Modules+= "management_groups"

Write-host @"
Please take the following actions before attempting to destroy this deployment.
  - Turn on the Jump Box Virtual Machine
"@

Write-host "This script will automatically continue in 30 seconds..."
Start-Sleep 30



$Modules | ForEach-Object {
	write-warning  "Working on $_ ..."
	Set-Location ..\$_
	
	if ((test-path ".terraform") -eq $true ) {
		terraform plan -destroy -out my.plan --var-file ../parameters.tfvars

		if ($lastexitcode -ne 0) { exit }

		terraform apply my.plan

		if ($lastexitcode -ne 0) { exit }

		remove-item my.plan -ErrorAction SilentlyContinue
		remove-item .terraform.lock.hcl -ErrorAction SilentlyContinue
        remove-item terraform.tfstate.backup -ErrorAction SilentlyContinue
		remove-item terraform.tfstate  -ErrorAction SilentlyContinue
		remove-item .terraform -Recurse   -ErrorAction SilentlyContinue
	}
}


