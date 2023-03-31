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
  policy_id           = azurerm_firewall_policy.policy.id
  tags                = var.tags
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
  name                = var.route_table_name
  resource_group_name = azurerm_virtual_network.vnet.resource_group_name
  location            = azurerm_virtual_network.vnet.location
  firewall_ip         = module.firewall.private_ip
  vnet_address_space  = var.address_space[0]
}

resource "azurerm_firewall_policy" "policy" {
  name                = var.policy_name
  resource_group_name = azurerm_virtual_network.vnet.resource_group_name
  location            = azurerm_virtual_network.vnet.location
}