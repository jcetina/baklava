resource "azurerm_virtual_network" "vnet" {
  name                = "azure-${var.vnet_location}"
  address_space       = var.cidr
  location            = var.vnet_location
  resource_group_name = var.rg_name
  # Send a global DNS server option for early boot, until puppet takes over
  # dns_servers = ["10.127.5.10"]
}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.gateway_subnet_prefixes
  # This switches on cidr size because of existing subnet builds
}

resource "azurerm_subnet" "vm" {
  name                 = "VmSubnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.vm_subnet_prefixes
}

resource "azurerm_public_ip" "gateway" {
  name                = "${azurerm_virtual_network.vnet.name}-vgw-pip"
  resource_group_name = var.rg_name
  location            = var.vnet_location

  # The configuration of the public IP resource determines whether the gateway is zone-redundant, or zonal.
  # A Standard SKU without specifying an availability zone allows the gateway to be zone-redundant and
  # span across all three zones.
  sku                     = "Standard"
  allocation_method       = "Static"
  idle_timeout_in_minutes = 15

  zones = ["1", "2", "3"]
}

resource "azurerm_virtual_network_gateway" "gateway" {
  name                = "${azurerm_virtual_network.vnet.name}-vgw"
  resource_group_name = var.rg_name
  location            = var.vnet_location

  type       = "Vpn"
  sku        = "VpnGw2AZ"
  vpn_type   = "RouteBased"
  enable_bgp = false

  ip_configuration {
    subnet_id            = azurerm_subnet.gateway.id
    public_ip_address_id = azurerm_public_ip.gateway.id
  }
}