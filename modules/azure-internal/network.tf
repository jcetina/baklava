resource "azurerm_virtual_network" "vnet" {
  name                = "azure-${var.vnet_location}"
  address_space       = var.cidr
  location            = var.vnet_location
  resource_group_name = var.vnet_rg
  # Send a global DNS server option for early boot, until puppet takes over
  # dns_servers = ["10.127.5.10"]
}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.vnet_rg
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.gateway_subnet_prefixes
  # This switches on cidr size because of existing subnet builds
}