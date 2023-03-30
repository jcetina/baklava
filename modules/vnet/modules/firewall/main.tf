resource "azurerm_firewall" "firewall" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier

  ip_configuration {
    name                 = "${var.name}-ip-config"
    subnet_id            = var.subnet_id
    public_ip_address_id = module.ip.id
  }
  zones = length(var.zones) == 0 ? null : var.zones
}

module "ip" {
  source              = "../public_ip"
  name                = "${azurerm_firewall.firewall.name}-ip"
  resource_group_name = azurerm_firewall.firewall.resource_group_name
  location            = azurerm_firewall.firewall.location
  zones               = var.zones
}
