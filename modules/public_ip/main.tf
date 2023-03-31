resource "azurerm_public_ip" "public_ip" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = var.sku
  zones               = length(var.zones) == 0 ? null : var.zones
}