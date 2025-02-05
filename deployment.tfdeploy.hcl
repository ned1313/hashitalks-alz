identity_token "azurerm" {
  audience = ["api://AzureADTokenExchange"]
}

deployment "alz" {
  inputs = {
    identity_token = identity_token.azurerm.jwt
    client_id      = var.client_id
    tenant_id      = var.tenant_id
  }
}