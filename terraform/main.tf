# provider "azurerm" {
#   # Configuration options
#   subscription_id = var.subscription_id
#   features {
    
#   }
# }

# resource "azurerm_resource_group" "gocloudops" {
#   name     = "gocloudops-resources"
#   location = "West Europe"
# }

# resource "azurerm_app_service_plan" "gocloudops" {
#   name                = "gocloudops-appserviceplan"
#   location            = azurerm_resource_group.gocloudops.location
#   resource_group_name = azurerm_resource_group.gocloudops.name

#   sku {
#     tier = "Standard"
#     size = "S1"
#   }
# }

# resource "azurerm_app_service" "gocloudops" {
#   name                = "gocloudops-app-service"
#   location            = azurerm_resource_group.gocloudops.location
#   resource_group_name = azurerm_resource_group.gocloudops.name
#   app_service_plan_id = azurerm_app_service_plan.gocloudops.id

#   site_config {
#     dotnet_framework_version = "v4.0"
#     scm_type                 = "LocalGit"
#   }

#   app_settings = {
#     "SOME_KEY" = "some-value"
#   }

#   connection_string {
#     name  = "Database"
#     type  = "SQLServer"
#     value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
#   }
# }


provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

# Resource Group
resource "azurerm_resource_group" "gocloudops" {
  name     = "gocloudops-resources"
  location = "West Europe"
}

# App Service Plan
resource "azurerm_app_service_plan" "gocloudops" {
  name                = "gocloudops-appserviceplan"
  location            = azurerm_resource_group.gocloudops.location
  resource_group_name = azurerm_resource_group.gocloudops.name

  sku {
    tier = "Standard"
    size = "S1"
  }

  reserved = true  # Required for Linux/Python
}

# Azure OpenAI
resource "azurerm_cognitive_account" "openai" {
  name                = "gocloudops-openai"
  location            = azurerm_resource_group.gocloudops.location
  resource_group_name = azurerm_resource_group.gocloudops.name
  kind                = "OpenAI"
  sku_name            = "S0"
  custom_subdomain_name = "gocloudops-openai"
}

resource "azurerm_cognitive_deployment" "gpt4omini" {
  name                 = "gpt4omini"
  cognitive_account_id = azurerm_cognitive_account.openai.id

  model {
    format  = "OpenAI"
    name    = "gpt-4o-mini"
    version = "2024-08-06"
  }

  sku {
    name     = "Standard"
    capacity = 1
  }


}

# App Service (Python)
resource "azurerm_app_service" "gocloudops" {
  name                = "gocloudops-app-service"
  location            = azurerm_resource_group.gocloudops.location
  resource_group_name = azurerm_resource_group.gocloudops.name
  app_service_plan_id = azurerm_app_service_plan.gocloudops.id

  site_config {
    python_version = "3.11"
    scm_type       = "LocalGit"
  }

  app_settings = {
    "AZURE_OPENAI_ENDPOINT"    = azurerm_cognitive_account.openai.endpoint
    "AZURE_OPENAI_API_KEY"     = azurerm_cognitive_account.openai.primary_access_key
    "AZURE_OPENAI_DEPLOYMENT"  = azurerm_cognitive_deployment.gpt4omini.name
  }
}
