provider "azurerm" {
  # Configuration options
  subscription_id = var.subscription_id
  features {
    
  }
}

resource "azurerm_resource_group" "gocloudops" {
  name     = "gocloudops-resources"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "gocloudops" {
  name                = "gocloudops-appserviceplan"
  location            = azurerm_resource_group.gocloudops.location
  resource_group_name = azurerm_resource_group.gocloudops.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "gocloudops" {
  name                = "gocloudops-app-service"
  location            = azurerm_resource_group.gocloudops.location
  resource_group_name = azurerm_resource_group.gocloudops.name
  app_service_plan_id = azurerm_app_service_plan.gocloudops.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}