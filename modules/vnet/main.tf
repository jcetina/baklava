resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
}

module "subnet" {
  source              = "../subnet"
  name                = "AzureFirewallSubnet"
  resource_group_name = azurerm_virtual_network.vnet.resource_group_name
  vnet_name           = azurerm_virtual_network.vnet.name
  address_prefixes    = var.firewall_subnet
}

module "firewall" {
  source              = "../firewall"
  name                = var.firewall_name
  resource_group_name = azurerm_virtual_network.vnet.resource_group_name
  location            = azurerm_virtual_network.vnet.location
  subnet_id           = module.subnet.id
  zones               = var.zones
}

resource "azurerm_subnet_nat_gateway_association" "firewall_association" {
  subnet_id      = module.subnet.id
  nat_gateway_id = module.nat_gateway.id
}

module "nat_gateway" {
  source              = "../nat_gw"
  name                = var.nat_gateway_name
  resource_group_name = azurerm_virtual_network.vnet.resource_group_name
  location            = azurerm_virtual_network.vnet.location
  ip_count            = var.nat_gw_ip_count
  zones               = var.zones
  idle_timeout        = var.nat_gw_idle_timeout
}

module "route_table" {
  source              = "../route_table"
  name                = "my-secure-route-table"
  resource_group_name = azurerm_virtual_network.vnet.resource_group_name
  location            = azurerm_virtual_network.vnet.location
  firewall_ip         = module.firewall.private_ip
  vnet_address_space  = var.address_space
}