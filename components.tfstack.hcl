component "bootstrap" {
  source = "./bootstrap"
  inputs = {
    hub_and_spoke_vnet_settings         = var.hub_and_spoke_vnet_settings
    hub_and_spoke_vnet_virtual_networks = var.hub_and_spoke_vnet_virtual_networks
    connectivity_type                   = var.connectivity_type
    connectivity_resource_groups        = var.connectivity_resource_groups
    virtual_wan_settings                = var.virtual_wan_settings
    virtual_wan_virtual_hubs            = var.virtual_wan_virtual_hubs
    management_resource_settings        = var.management_resource_settings
    management_group_settings           = var.management_group_settings
    starter_locations                   = var.starter_locations
    subscription_id_connectivity        = var.subscription_id_connectivity
    subscription_id_identity            = var.subscription_id_identity
    subscription_id_management          = var.subscription_id_management
    root_parent_management_group_id     = var.root_parent_management_group_id
    enable_telemetry                    = var.enable_telemetry
    custom_replacements                 = var.custom_replacements
    tags                                = var.tags

  }
  providers = {
    azurerm = provider.azurerm.main
    azapi   = provider.azapi.main
    modtm   = provider.modtm.main
    random  = provider.random.main
  }
}

component "management_resources" {
  source = "./management_resources"
  inputs = {
    enable_telemetry             = var.enable_telemetry
    management_resource_settings = module.bootstrap.management_resource_settings
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
    management_group_settings = module.bootstrap.management_group_settings
    dependencies              = module.bootstrap.management_group_dependencies
  }
  providers = {
    azapi  = provider.azapi.main
    modtm  = provider.modtm.main
    random = provider.random.main
    alz    = provider.alz.main
    time   = provider.time.main
  }

  # Need to figure out policy assignments and role assignments dependencies
}

component "resource_groups" {
  source   = "Azure/avm-res-resources-resourcegroup/azurerm"
  version  = "0.2.0"
  for_each = module.bootstrap.connectivity_resource_groups
  inputs = {
    name             = each.value.name
    location         = each.value.location
    enable_telemetry = var.enable_telemetry
    tags             = var.tags
  }
  providers = {
    azurerm = provider.azurerm.connectivity
    modtm   = provider.modtm.main
    random  = provider.random.main
  }
}

component "hub_and_spoke_vnet" {
  source = "./hub-and-spoke-vnet"
  inputs = {
    hub_and_spoke_networks_settings = module.bootstrap.hub_and_spoke_vnet_settings
    hub_virtual_networks            = module.bootstrap.hub_and_spoke_vnet_virtual_networks
    enable_telemetry                = var.enable_telemetry
    tags                            = var.tags
  }
  providers = {
    azurerm = provider.azurerm.connectivity
    modtm   = provider.modtm.main
    random  = provider.random.main
  }
}