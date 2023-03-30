resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
}

module "subnet" {
  source              = "./modules/subnet"
  name                = "AzureFirewallSubnet"
  resource_group_name = azurerm_virtual_network.vnet.resource_group_name
  vnet_name           = azurerm_virtual_network.vnet.name
  address_prefixes    = var.firewall_subnet
}

module "firewall" {
  source              = "./modules/firewall"
  name                = var.firewall_name
  resource_group_name = azurerm_virtual_network.vnet.resource_group_name
  location            = azurerm_virtual_network.vnet.location
  subnet_id           = module.subnet.id
  zones               = var.zones
}

module "nat_gateway" {
  source              = "./modules/nat_gw"
  name                = var.nat_gateway_name
  resource_group_name = azurerm_virtual_network.vnet.resource_group_name
  location            = azurerm_virtual_network.vnet.location
  ip_count            = var.nat_gateway_ip_count
  zones               = var.zones
  idle_timeout        = var.nat_gw_idle_timeout
}