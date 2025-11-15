resource "azurerm_resource_group" "rg" {
  name     = "rg-search-app"
  location = "East US"
}

resource "azurerm_service_plan" "plan" {
  name                = "search-app-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "B1"
  os_type             = "Linux"  # ✅ Required for Linux Web Apps
}

resource "azurerm_linux_web_app" "webapp" {
  name                = "search-demo-webapp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    linux_fx_version = "PYTHON|3.10"
  }
}