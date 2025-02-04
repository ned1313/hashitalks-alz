# Initialize the Terraform configuration
terraform `
  -chdir="." `
  init

# Check and Set Subscription ID
if($null -eq $env:ARM_SUBSCRIPTION_ID -or $env:ARM_SUBSCRIPTION_ID -eq "") {
    Write-Verbose "Setting environment variable ARM_SUBSCRIPTION_ID"
    $subscriptionId = $(az account show --query id -o tsv)
    if($null -eq $subscriptionId -or $subscriptionId -eq "") {
        Write-Error "Subscription ID not found. Please ensure you are logged in to Azure and have selected a subscription. Use 'az account show' to check."
        return
    }
    $env:ARM_SUBSCRIPTION_ID = $subscriptionId
    Write-Verbose "Environment variable ARM_SUBSCRIPTION_ID set to $subscriptionId"
}

# Run the Terraform plan
terraform `
  -chdir="." `
  plan `
  -out=tfplan

# Review the Terraform plan
terraform `
  -chdir="." `
  show `
  tfplan

Write-Host ""
$deployApproved = Read-Host -Prompt "Type 'yes' and hit Enter to continue with the full deployment"
Write-Host ""

if($deployApproved -ne "yes") {
  Write-Error "Deployment was not approved. Exiting..."
  exit 1
}

# Apply the Terraform plan
terraform `
  -chdir="." `
  apply `
  tfplan
