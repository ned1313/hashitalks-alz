component "resource_groups" {
  source = "./resource_groups"
  inputs = {
    enable_telemetry = var.enable_telemetry
    connectivity_resource_groups  = local.connectivity_resource_groups
    tags             = var.tags
  }
  providers = {
    azurerm = provider.azurerm.connectivity
    modtm   = provider.modtm.main
    random  = provider.random.main
  }
}

component "management_resources" {
  source = "./management_resources"
  inputs = {
    enable_telemetry             = var.enable_telemetry
    management_resource_settings = local.management_resource_settings
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
    management_group_settings = local.management_group_settings
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

  # Need to figure out policy assignments and role assignments dependencies
}

component "hub_and_spoke_vnet" {
  source = "./hub-and-spoke-vnet"
  inputs = {
    hub_and_spoke_networks_settings = local.hub_and_spoke_vnet_settings
    hub_virtual_networks            = local.hub_and_spoke_vnet_virtual_networks
    enable_telemetry                = var.enable_telemetry
    tags                            = var.tags
  }
  providers = {
    azapi   = provider.azapi.main
    azurerm = provider.azurerm.connectivity
    modtm   = provider.modtm.main
    random  = provider.random.main
  }

  depends_on = [
    component.resource_groups
  ]
}