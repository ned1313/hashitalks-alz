identity_token "azurerm" {
  audience = ["api://AzureADTokenExchange"]
}

deployment "alz" {
  inputs = {
    identity_token = identity_token.azurerm.jwt
    client_id      = "461ee346-9821-44ed-aba5-fa989c69dca3"
    tenant_id      = "ff5b675b-cd9a-46ea-94c5-6c7e19a18f82"
  }
}