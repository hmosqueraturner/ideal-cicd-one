provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "West Europe"
}

resource "azurerm_container_registry" "example" {
  name                     = "example-container-registry"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  sku                      = "Basic"
  admin_enabled            = true
  georeplication_locations = ["West Europe"]
}

resource "azurerm_container_registry_webhook" "example" {
  name                = "example-webhook"
  resource_group_name = azurerm_resource_group.example.name
  registry_name       = azurerm_container_registry.example.name
  service_uri         = "https://example.com/webhook"
  actions             = ["push"]
}

resource "azurerm_container_group" "example" {
  name                = "example-container-group"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  os_type             = "Linux"

  container {
    name   = "example-container"
    image  = "your-docker-image:tag"
    cpu    = "1"
    memory = "1.5"
    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}
