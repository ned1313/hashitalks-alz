locals {
  subscription_id     = data.azapi_client_config.current.subscription_id
  resource_group_name = local.resource_group_name
  resource_type       = "Microsoft.OperationalInsights/workspaces"
  resource_names      = [local.log_analytics_workspace_name]
  log_analytics_workspace_id = provider::azapi::resource_group_resource_id(
    local.subscription_id,
    local.resource_group_name,
    local.resource_type,
    local.resource_names
  )
}

module "alz_architecture" {
  source  = "Azure/avm-ptn-alz/azurerm"
  version = "~> 0.10"

  architecture_name  = "alz"
  parent_resource_id = data.azapi_client_config.current.tenant_id
  location           = var.location

  policy_default_values = {
    log_analytics_workspace_id = jsonencode({ Value = module.alz_management.resource_id })
  }

  dependencies = {
    policy_role_assignments = [
      module.alz_management.resource_id
    ]
  }
}