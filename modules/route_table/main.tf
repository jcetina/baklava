resource "azurerm_route_table" "route_table" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  route {
    name                   = "ToFirewall"
    address_prefix         = "0.0.0.0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.firewall_ip
  }

  route {
    name           = "VnetRoute"
    address_prefix = var.vnet_address_space
    next_hop_type  = "VnetLocal"
  }

  tags = var.tags
}