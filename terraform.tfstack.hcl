
  required_providers {
    alz = {
      source  = "Azure/alz"
      version = "~> 0.16"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    modtm = {
      source  = "Azure/modtm"
      version = "~> 0.3"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
  }

provider "local" "main" {
  config {}
}

provider "modtm" "main" {
  config {}
}

provider "random" "main" {
  config {}
}

provider "time" "main" {
  config {}
}

provider "alz" "main" {
  config {
  use_oidc = true
  oidc_token = var.identity_token
  client_id = var.client_id
  tenant_id = var.tenant_id
  library_overwrite_enabled = true
  library_references = [
    {
      custom_url = "${path.root}/lib"
    }
  ]
  }
}

provider "azapi" "main" {
  config {
  skip_provider_registration = true
  use_oidc = true
  oidc_token = var.identity_token
  client_id = var.client_id
  tenant_id = var.tenant_id
  subscription_id            = var.subscription_id_management
  }
}

provider "azurerm" "main" {
  config {
  resource_provider_registrations = "none"
  use_oidc = true
  oidc_token = var.identity_token
  client_id = var.client_id
  tenant_id = var.tenant_id
  subscription_id                 = var.subscription_id_main
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  }
}

provider "azurerm" "management" {
  config {
  resource_provider_registrations = "none"
  use_oidc = true
  oidc_token = var.identity_token
  client_id = var.client_id
  tenant_id = var.tenant_id
  subscription_id                 = var.subscription_id_management
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  }
}

provider "azurerm" "connectivity" {
  config {
  resource_provider_registrations = "none"
  use_oidc = true
  oidc_token = var.identity_token
  client_id = var.client_id
  tenant_id = var.tenant_id
  subscription_id                 = var.subscription_id_connectivity
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  }
}
