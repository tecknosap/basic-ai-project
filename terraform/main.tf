# =====================================================
# Random ID generation for unique suffix
# =====================================================
resource "random_id" "suffix" {
  byte_length = 4
}



provider "azurerm" {
  # Configuration options
  subscription_id = var.subscription_id
  features {
    
  }
}

resource "azurerm_resource_group" "gocloudops" {
  name     =  "${var.resource_group_name}-${random_id.suffix.hex}"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "gocloudops" {
  name                = "${var.app_service_plan}-${random_id.suffix.hex}"
  location            = azurerm_resource_group.gocloudops.location
  resource_group_name = azurerm_resource_group.gocloudops.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "gocloudops" {
  name                =  "${var.app_service}-${random_id.suffix.hex}"
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








