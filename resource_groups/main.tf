variable "connectivity_resource_groups" {
  description = "Map of resource groups to create"
  type        = map(object({
    name     = string
    location = string
  }))
}

variable "enable_telemetry" {
  description = "Flag to enable telemetry"
  type        = bool
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}

module "resource_groups" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.2.0"

  for_each = var.connectivity_resource_groups

  name             = each.value.name
  location         = each.value.location
  enable_telemetry = var.enable_telemetry
  tags             = var.tags
}