resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
}

module "subnet" {
  source               = "./modules/subnet"
  name                 = "${var.name}-fw-subnet"
  resource_group_name  = azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = var.name
  address_prefixes     = var.firewall_subnet
}

module "firewall" {
  source              = "./modules/firewall"
  name                = var.firewall_name
  resource_group_name = azurerm_virtual_network.vnet.resource_group_name
  location            = azurerm_virtual_network.vnet.location
  subnet_id           = azurerm_subnet.firewall_subnet.id
  zones               = var.zones
}