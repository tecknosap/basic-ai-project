resource "azurerm_resource_group" "rg" {
  name     = "rg-search-app-01"
  location = "East US 2"
}

resource "azurerm_service_plan" "plan" {
  name                = "search-app-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "B1"
  os_type             = "Linux"
}

resource "azurerm_linux_web_app" "webapp" {
  name                = "search-demo-webapp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    # Removed linux_fx_version
    always_on = true
  }

  # Set Python version via app_settings
  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "PYTHON_VERSION"                      = "3.10"
  }
}

