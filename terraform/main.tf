resource "random_integer" "number" {
  min = 1
  max = 99
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.project_name}-${random_integer.number.id}-rg"
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = "acr${var.project_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_container_group" "aci" {
  name                = "${var.project_name}-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "Public"
  dns_name_label      = "${var.project_name}-app"
  os_type             = "Linux"
  restart_policy      = "OnFailure"

  image_registry_credential {
    server   = azurerm_container_registry.acr.login_server
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
  }

  container {
    name   = "mercury"
    image  = "${azurerm_container_registry.acr.login_server}/mercury:latest"
    cpu    = "1"
    memory = "1"

    ports {
      port     = 8000
      protocol = "TCP"
    }
  }
}
