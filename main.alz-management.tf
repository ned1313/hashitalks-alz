locals {
  suffix                       = "${var.environment}-${var.region}-${random_integer.main.result}"
  automation_account_name      = "aa-${local.suffix}"
  log_analytics_workspace_name = "law-${local.suffix}"
  resource_group_name          = "rg-management-${var.region}-${random_integer.main.result}"
}

resource "random_integer" "main" {
  max = 99999
  min = 10000
}

module "alz_management" {
  source  = "Azure/avm-ptn-alz-management/azurerm"
  version = "0.6.0"

  automation_account_name      = "aa-prod-eus-001"
  location                     = var.location
  log_analytics_workspace_name = "law-prod-eus-001"
  resource_group_name          = "rg-management-eus-001"
}