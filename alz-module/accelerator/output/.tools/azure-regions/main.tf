terraform {
  required_providers {
    azapi = {
        source  = "azure/azapi"
        version = "~> 2.0"
    }
  }
}

module "regions" {
  source                    = "Azure/avm-utl-regions/azurerm"
  version                   = "0.3.0"
  use_cached_data           = false
  availability_zones_filter = false
  recommended_filter        = false
}

locals {
  regions = { for region in module.regions.regions_by_name : region.name => {
    display_name = region.display_name
    zones        = region.zones == null ? [] : [for zone in region.zones : tostring(zone)]
    }
  }
}

output "regions_and_zones" {
  value = local.regions
}
