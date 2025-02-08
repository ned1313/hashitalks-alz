/*
--- Built-in Replacements ---
This file contains built-in replacements to avoid repeating the same hard-coded values.
Replacements are denoted by the dollar-dollar curly braces token (e.g. ${var.starter_locations[0]}). The following details each built-in replacemnets that you can use:
`starter_location_01`: This the primary an Azure location sourced from the `starter_locations` variable. This can be used to set the location of resources.
`starter_location_02` to `starter_location_10`: These are the secondary Azure locations sourced from the `starter_locations` variable. This can be used to set the location of resources.
`starter_location_01_availability_zones` to `starter_location_10_availability_zones`: These are the availability zones for the Azure locations sourced from the `starter_locations` variable. This can be used to set the availability zones of resources.
`starter_location_01_virtual_network_gateway_sku_express_route` to `starter_location_10_virtual_network_gateway_sku_express_route`: These are the default SKUs for the Express Route virtual network gateways based on the Azure locations sourced from the `starter_locations` variable. This can be used to set the SKU of the virtual network gateways.
`starter_location_01_virtual_network_gateway_sku_vpn` to `starter_location_10_virtual_network_gateway_sku_vpn`: These are the default SKUs for the VPN virtual network gateways based on the Azure locations sourced from the `starter_locations` variable. This can be used to set the SKU of the virtual network gateways.
`root_parent_management_group_id`: This is the id of the management group that the ALZ hierarchy will be nested under.
`subscription_id_identity`: The subscription ID of the subscription to deploy the identity resources to, sourced from the variable `subscription_id_identity`.
`subscription_id_connectivity`: The subscription ID of the subscription to deploy the connectivity resources to, sourced from the variable `subscription_id_connectivity`.
`subscription_id_management`: The subscription ID of the subscription to deploy the management resources to, sourced from the variable `subscription_id_management`.
*/

/*
--- Custom Replacements ---
You can define custom replacements to use throughout the configuration.
*/

locals {
      # Defender email security contact
      defender_email_security_contact = "ned@nedinthecloud.com"

      # Resource group names
      management_resource_group_name                 = "rg-management-${var.starter_locations[0]}"
      connectivity_hub_primary_resource_group_name   = "rg-hub-${var.starter_locations[0]}"
      connectivity_hub_secondary_resource_group_name = "rg-hub-${var.starter_locations[1]}"
      dns_resource_group_name                        = "rg-hub-dns-${var.starter_locations[0]}"
      ddos_resource_group_name                       = "rg-hub-ddos-${var.starter_locations[0]}"
      asc_export_resource_group_name                 = "rg-asc-export-${var.starter_locations[0]}"

      # Resource names
      log_analytics_workspace_name            = "law-management-${var.starter_locations[0]}"
      ddos_protection_plan_name               = "ddos-${var.starter_locations[0]}"
      automation_account_name                 = "aa-management-${var.starter_locations[0]}"
      ama_user_assigned_managed_identity_name = "uami-management-ama-${var.starter_locations[0]}"
      dcr_change_tracking_name                = "dcr-change-tracking"
      dcr_defender_sql_name                   = "dcr-defender-sql"
      dcr_vm_insights_name                    = "dcr-vm-insights"

      # Resource names primary connectivity
      primary_virtual_network_name          = "vnet-hub-${var.starter_locations[0]}"
      primary_subnet_nva_name               = "subnet-nva-${var.starter_locations[0]}"
      primary_route_table_firewall_name     = "rt-hub-fw-${var.starter_locations[0]}"
      primary_route_table_user_subnets_name = "rt-hub-std-${var.starter_locations[0]}"
      primary_private_dns_resolver_name     = "pdr-hub-dns-${var.starter_locations[0]}"

      # Resource names secondary connectivity
      secondary_virtual_network_name          = "vnet-hub-${var.starter_locations[1]}"
      secondary_subnet_nva_name               = "subnet-nva-${var.starter_locations[1]}"
      secondary_route_table_firewall_name     = "rt-hub-fw-${var.starter_locations[1]}"
      secondary_route_table_user_subnets_name = "rt-hub-std-${var.starter_locations[1]}"
      secondary_private_dns_resolver_name     = "pdr-hub-dns-${var.starter_locations[1]}"

      # Private DNS Zones primary
      primary_auto_registration_zone_name = "${var.starter_locations[0]}.azure.local"

      # Private DNS Zones secondary
      secondary_auto_registration_zone_name = "${var.starter_locations[1]}.azure.local"

      # IP Ranges Primary
      # Regional Address Space: 10.0.0.0/16
      primary_hub_address_space                          = "10.0.0.0/16"
      primary_hub_virtual_network_address_space          = "10.0.0.0/22"
      primary_nva_subnet_address_prefix                  = "10.0.0.0/26"
      primary_nva_ip_address                             = "10.0.0.4"
      primary_gateway_subnet_address_prefix              = "10.0.0.128/27"
      primary_private_dns_resolver_subnet_address_prefix = "10.0.0.160/28"

      # IP Ranges Secondary
      # Regional Address Space: 10.1.0.0/16
      secondary_hub_address_space                          = "10.1.0.0/16"
      secondary_hub_virtual_network_address_space          = "10.1.0.0/22"
      secondary_nva_subnet_address_prefix                  = "10.1.0.0/26"
      secondary_nva_ip_address                             = "10.1.0.4"
      secondary_gateway_subnet_address_prefix              = "10.1.0.128/27"
      secondary_private_dns_resolver_subnet_address_prefix = "10.1.0.160/28"

    /* 
  --- Custom Resource Group Identifier Replacements ---
  You can define custom resource group identifiers to use throughout the configuration. 
  You can only use the templated variables and custom names in this section.
  NOTE: You cannot refer to another custom resource group identifier in this variable.
  */
    resource_group_identifiers = {
      management_resource_group_id           = "/subscriptions/${var.subscription_id_management}/resourcegroups/${local.management_resource_group_name}"
      ddos_protection_plan_resource_group_id = "/subscriptions/${var.subscription_id_connectivity}/resourcegroups/${local.ddos_resource_group_name}"
    }

    /* 
  --- Custom Resource Identifier Replacements ---
  You can define custom resource identifiers to use throughout the configuration. 
  You can only use the templated variables, custom names and customer resource group identifiers in this variable.
  NOTE: You cannot refer to another custom resource identifier in this variable.
  */
    resource_identifiers = {
      ama_change_tracking_data_collection_rule_id = "${local.resource_group_identifiers.management_resource_group_id}/providers/Microsoft.Insights/dataCollectionRules/${local.dcr_change_tracking_name}"
      ama_mdfc_sql_data_collection_rule_id        = "${local.resource_group_identifiers.management_resource_group_id}/providers/Microsoft.Insights/dataCollectionRules/${local.dcr_defender_sql_name}"
      ama_vm_insights_data_collection_rule_id     = "${local.resource_group_identifiers.management_resource_group_id}/providers/Microsoft.Insights/dataCollectionRules/${local.dcr_vm_insights_name}"
      ama_user_assigned_managed_identity_id       = "${local.resource_group_identifiers.management_resource_group_id}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${local.ama_user_assigned_managed_identity_name}"
      log_analytics_workspace_id                  = "${local.resource_group_identifiers.management_resource_group_id}/providers/Microsoft.OperationalInsights/workspaces/${local.log_analytics_workspace_name}"
      ddos_protection_plan_id                     = "${local.resource_group_identifiers.ddos_protection_plan_resource_group_id}/providers/Microsoft.Network/ddosProtectionPlans/${local.ddos_protection_plan_name}"
    }

  enable_telemetry = false

  /*
--- Tags ---
This variable can be used to apply tags to all resources that support it. Some resources allow overriding these tags.
*/
  tags = {
    deployed_by = "HCP Terraform Stacks"
    source      = "Azure Landing Zones Accelerator"
  }

  /* 
--- Management Resources ---
You can use this section to customize the management resources that will be deployed.
*/

  management_resource_settings = {
    automation_account_name      = local.automation_account_name
    location                     = var.starter_locations[0]
    log_analytics_workspace_name = local.log_analytics_workspace_name
    resource_group_name          = local.management_resource_group_name
    user_assigned_managed_identities = {
      ama = {
        name = local.ama_user_assigned_managed_identity_name
      }
    }
    data_collection_rules = {
      change_tracking = {
        name = local.dcr_change_tracking_name
      }
      defender_sql = {
        name = local.dcr_defender_sql_name
      }
      vm_insights = {
        name = local.dcr_vm_insights_name
      }
    }
  }

  /* 
--- Management Groups and Policy ---
You can use this section to customize the management groups and policies that will be deployed.
You can further configure management groups and policy by supplying a `lib` folder. This is detailed in the Accelerator documentation.
*/

  management_group_settings = {
    location           = var.starter_locations[0]
    parent_resource_id = var.root_parent_management_group_id
    policy_default_values = {
      ama_change_tracking_data_collection_rule_id = local.resource_identifiers.ama_change_tracking_data_collection_rule_id
      ama_mdfc_sql_data_collection_rule_id        = local.resource_identifiers.ama_mdfc_sql_data_collection_rule_id
      ama_vm_insights_data_collection_rule_id     = local.resource_identifiers.ama_vm_insights_data_collection_rule_id
      ama_user_assigned_managed_identity_id       = local.resource_identifiers.ama_user_assigned_managed_identity_id
      ama_user_assigned_managed_identity_name     = local.ama_user_assigned_managed_identity_name
      log_analytics_workspace_id                  = local.resource_identifiers.log_analytics_workspace_id
      ddos_protection_plan_id                     = local.resource_identifiers.ddos_protection_plan_id
      private_dns_zone_subscription_id            = var.subscription_id_connectivity
      private_dns_zone_region                     = var.starter_locations[0]
      private_dns_zone_resource_group_name        = local.dns_resource_group_name
    }
    subscription_placement = {
      identity = {
        subscription_id       = var.subscription_id_identity
        management_group_name = "identity"
      }
      connectivity = {
        subscription_id       = var.subscription_id_connectivity
        management_group_name = "connectivity"
      }
      management = {
        subscription_id       = var.subscription_id_management
        management_group_name = "management"
      }
    }
    policy_assignments_to_modify = {
      alz = {
        policy_assignments = {
          Deploy-MDFC-Config-H224 = {
            parameters = {
              ascExportResourceGroupName                  = local.asc_export_resource_group_name
              ascExportResourceGroupLocation              = var.starter_locations[0]
              emailSecurityContact                        = local.defender_email_security_contact
              enableAscForServers                         = "DeployIfNotExists"
              enableAscForServersVulnerabilityAssessments = "DeployIfNotExists"
              enableAscForSql                             = "DeployIfNotExists"
              enableAscForAppServices                     = "DeployIfNotExists"
              enableAscForStorage                         = "DeployIfNotExists"
              enableAscForContainers                      = "DeployIfNotExists"
              enableAscForKeyVault                        = "DeployIfNotExists"
              enableAscForSqlOnVm                         = "DeployIfNotExists"
              enableAscForArm                             = "DeployIfNotExists"
              enableAscForOssDb                           = "DeployIfNotExists"
              enableAscForCosmosDbs                       = "DeployIfNotExists"
              enableAscForCspm                            = "DeployIfNotExists"
            }
          }
        }
      }
      /*
    # Example of how to update a policy assignment enforcement mode for DDOS Protection Plan
    connectivity = {
      policy_assignments = {
        Enable-DDoS-VNET = {
          enforcement_mode = "DoNotEnforce"
        }
      }
    }
    */
      /*
    # Example of how to update a policy assignment enforcement mode for Private Link DNS Zones
    corp = {
      policy_assignments = {
        Deploy-Private-DNS-Zones = {
          enforcement_mode = "DoNotEnforce"
        }
      }
    }
    */
    }
  }

  /* 
--- Connectivity - Hub and Spoke Virtual Network ---
You can use this section to customize the hub virtual networking that will be deployed.
*/

  connectivity_type = "hub_and_spoke_vnet"

  connectivity_resource_groups = {
    ddos = {
      name     = local.ddos_resource_group_name
      location = var.starter_locations[0]
    }
    vnet_primary = {
      name     = local.connectivity_hub_primary_resource_group_name
      location = var.starter_locations[0]
    }
    vnet_secondary = {
      name     = local.connectivity_hub_secondary_resource_group_name
      location = var.starter_locations[1]
    }
    dns = {
      name     = local.dns_resource_group_name
      location = var.starter_locations[0]
    }
  }

  hub_and_spoke_vnet_settings = {
    ddos_protection_plan = {
      name                = local.ddos_protection_plan_name
      resource_group_name = local.ddos_resource_group_name
      location            = var.starter_locations[0]
    }
  }

  hub_and_spoke_vnet_virtual_networks = {
    primary = {
      hub_virtual_network = {
        name                          = local.primary_virtual_network_name
        resource_group_name           = local.connectivity_hub_primary_resource_group_name
        location                      = var.starter_locations[0]
        address_space                 = [local.primary_hub_virtual_network_address_space]
        routing_address_space         = [local.primary_hub_address_space]
        route_table_name_firewall     = local.primary_route_table_firewall_name
        route_table_name_user_subnets = local.primary_route_table_user_subnets_name
        ddos_protection_plan_id       = local.resource_identifiers.ddos_protection_plan_id
        hub_router_ip_address         = local.primary_nva_ip_address
        subnets = {
          nva = {
            name             = local.primary_subnet_nva_name
            address_prefixes = [local.primary_nva_subnet_address_prefix]
          }
        }
      }
      private_dns_zones = {
        resource_group_name            = local.dns_resource_group_name
        is_primary                     = true
        auto_registration_zone_enabled = true
        auto_registration_zone_name    = "${local.primary_auto_registration_zone_name}.azure.local"
        subnet_address_prefix          = "${local.primary_private_dns_resolver_subnet_address_prefix}"
        private_dns_resolver = {
          name = local.primary_private_dns_resolver_name
        }
      }
    }
    secondary = {
      hub_virtual_network = {
        name                          = local.secondary_virtual_network_name
        resource_group_name           = local.connectivity_hub_secondary_resource_group_name
        location                      = var.starter_locations[1]
        address_space                 = [local.secondary_hub_virtual_network_address_space]
        routing_address_space         = [local.secondary_hub_address_space]
        route_table_name_firewall     = local.secondary_route_table_firewall_name
        route_table_name_user_subnets = local.secondary_route_table_user_subnets_name
        ddos_protection_plan_id       = local.resource_identifiers.ddos_protection_plan_id
        hub_router_ip_address         = local.secondary_nva_ip_address
        subnets = {
          nva = {
            name             = local.secondary_subnet_nva_name
            address_prefixes = [local.secondary_nva_subnet_address_prefix]
          }
        }
      }
      private_dns_zones = {
        resource_group_name            = local.dns_resource_group_name
        is_primary                     = false
        auto_registration_zone_enabled = true
        auto_registration_zone_name    = "${local.secondary_auto_registration_zone_name}.azure.local"
        subnet_address_prefix          = "${local.secondary_private_dns_resolver_subnet_address_prefix}"
        private_dns_resolver = {
          name = local.secondary_private_dns_resolver_name
        }
      }
    }
  }
}