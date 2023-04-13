resource "azurerm_firewall" "firewall" {
  name                = var.fw_name
  location            = var.location
  resource_group_name = var.rg_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  zones               = var.zones
  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.firewall_ip.id
  }
}

resource "azurerm_public_ip" "firewall_ip" {
  name                = "${var.fw_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.zones
}

resource "azurerm_firewall_policy" "policy" {
  name                = "${var.fw_name}-policy"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_firewall_policy_rule_collection_group" "first" {
  name               = "${azurerm_firewall_policy.name}-rcg-first"
  firewall_policy_id = azurerm_firewall_policy.policy.id
  priority           = 100

  network_rule_collection {
    count    = var.breakglass ? 1 : 0
    name     = "breakglass"
    priority = 100
    action   = "Allow"
    rule {
      name                  = "AllowAll"
      protocols             = ["Any"]
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["1-65535"]
    }
  }

}