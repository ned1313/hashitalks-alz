identity_token "azurerm" {
  audience = ["api://AzureADTokenExchange"]
}

deployment "alz" {
  inputs = {
    identity_token = identity_token.azurerm.jwt
    client_id      = "461ee346-9821-44ed-aba5-fa989c69dca3"
    tenant_id      = "ff5b675b-cd9a-46ea-94c5-6c7e19a18f82"
    starter_locations = ["eastus2","westus2"]
    subscription_id_main = "8504c123-c9b5-4a0a-acd9-e5162d77a559"
    subscription_id_connectivity = "de311b7b-392e-438e-863d-235abc9c1cf1"
    subscription_id_identity = "aeff45a4-109b-45c7-bb9a-7e02fac8110e"
    subscription_id_management = "8504c123-c9b5-4a0a-acd9-e5162d77a559"
    root_parent_management_group_id = "ff5b675b-cd9a-46ea-94c5-6c7e19a18f82"
    tags = {
      "alz:environment" = "dev"
    }
  }
}