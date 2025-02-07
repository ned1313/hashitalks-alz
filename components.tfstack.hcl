component "bootstrap" {
  source = "./bootstrap"
  inputs = {
    hub_and_spoke_vnet_settings         = local.hub_and_spoke_vnet_settings
    hub_and_spoke_vnet_virtual_networks = local.hub_and_spoke_vnet_virtual_networks
    connectivity_type                   = local.connectivity_type
    connectivity_resource_groups        = local.connectivity_resource_groups
    management_resource_settings        = local.management_resource_settings
    management_group_settings           = local.management_group_settings
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
    dependencies              = component.bootstrap.management_group_dependencies
  }
  providers = {
    azapi     = provider.azapi.main
    modtm     = provider.modtm.main
    random    = provider.random.main
    alz       = provider.alz.main
    time      = provider.time.main
    terraform = provider.terraform.main
  }

  # Need to figure out policy assignments and role assignments dependencies
}

component "resource_groups" {
  source   = "Azure/avm-res-resources-resourcegroup/azurerm"
  version  = "0.2.0"
  for_each = component.bootstrap.connectivity_resource_groups
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