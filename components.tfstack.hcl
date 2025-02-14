component "bootstrap" {
  source = "./bootstrap"
  inputs = {
    starter_locations                   = var.starter_locations
    root_parent_management_group_id     = var.root_parent_management_group_id
    subscription_id_connectivity        = var.subscription_id_connectivity
    subscription_id_identity            = var.subscription_id_identity
    subscription_id_management          = var.subscription_id_management
    custom_replacements                 = local.custom_replacements
    hub_and_spoke_vnet_settings         = local.hub_and_spoke_vnet_settings
    hub_and_spoke_vnet_virtual_networks = local.hub_and_spoke_vnet_virtual_networks
    virtual_wan_settings                = local.virtual_wan_settings
    virtual_wan_virtual_hubs            = local.virtual_wan_virtual_hubs
    management_resource_settings        = local.management_resource_settings
    management_group_settings           = local.management_group_settings
    connectivity_resource_groups        = local.connectivity_resource_groups
    connectivity_type                   = local.connectivity_type
    enable_telemetry                    = var.enable_telemetry
    tags                                = var.tags
  }
  providers = {
    azurerm = provider.azurerm.connectivity
    azapi   = provider.azapi.main
    modtm   = provider.modtm.main
    random  = provider.random.main
  }
}

component "management_resources" {
  source = "./management_resources"
  inputs = {
    enable_telemetry             = var.enable_telemetry
    management_resource_settings = component.bootstrap.management_resource_settings
    tags                         = var.tags
  }
  providers = {
    azurerm = provider.azurerm.management
    azapi   = provider.azapi.main
    modtm   = provider.modtm.main
    random  = provider.random.main
  }
}

component "management_groups" {
  source = "./management_groups"
  inputs = {
    enable_telemetry          = var.enable_telemetry
    management_group_settings = component.bootstrap.management_group_settings
  }
  providers = {
    azapi     = provider.azapi.main
    modtm     = provider.modtm.main
    random    = provider.random.main
    alz       = provider.alz.main
    time      = provider.time.main
    terraform = provider.terraform.main
  }

  depends_on = [
    component.management_resources,
    component.hub_and_spoke_vnet
  ]
}

component "hub_and_spoke_vnet" {
  source = "./hub-and-spoke-vnet"
  inputs = {
    hub_and_spoke_networks_settings = component.bootstrap.hub_and_spoke_vnet_settings
    hub_virtual_networks            = component.bootstrap.hub_and_spoke_vnet_virtual_networks
    enable_telemetry                = var.enable_telemetry
    tags                            = var.tags
  }
  providers = {
    azapi   = provider.azapi.main
    azurerm = provider.azurerm.connectivity
    modtm   = provider.modtm.main
    random  = provider.random.main
  }
}