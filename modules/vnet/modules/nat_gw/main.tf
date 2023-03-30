resource "azurerm_nat_gateway" "nat_gateway" {
  name                    = var.name
  location                = var.location
  resource_group_name     = var.name
  sku_name                = var.sku
  idle_timeout_in_minutes = var.idle_timeout
  zones                   = length(var.zones) == 0 ? null : var.zones
  tags                    = var.tags
}

module "public_ip" {
  for_each            = var.ip_count == 1 ? ["1"] : []
  source              = "../public_ip"
  name                = "${var.name}-public-ip-${each.key}"
  resource_group_name = var.resource_group_name
  location            = var.location
  zones               = var.zones
}

resource "azurerm_nat_gateway_public_ip_association" "association" {
  for_each             = var.ip_count == 1 ? ["1"] : []
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = module.public_ip[each.key].id
}

resource "azurerm_public_ip_prefix" "prefix" {
  for_each            = var.ip_count > 1 ? ["1"] : []
  name                = "${var.name}-public-ip-prefix-${each.key}"
  resource_group_name = var.resource_group_name
  location            = var.location
  prefix_length       = 32 - log(var.ip_count, 2)
  zones               = length(var.zones) == 0 ? null : var.zones
  tags                = var.tags
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "association" {
  for_each            = var.ip_count > 1 ? ["1"] : []
  nat_gateway_id      = azurerm_nat_gateway.nat_gateway.id
  public_ip_prefix_id = azurerm_public_ip_prefix.prefix[each.key].id
}