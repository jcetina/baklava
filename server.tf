module "server_subnet" {
  source              = "./modules/subnet"
  name                = "ServerSubnet"
  resource_group_name = data.azurerm_resource_group.rg.name
  vnet_name           = module.vnet.name
  address_prefixes    = [local.subnets["ServerSubnet"]]
}

resource "azurerm_subnet_route_table_association" "server_subnet_association" {
  subnet_id      = module.server_subnet.id
  route_table_id = module.vnet.route_table_id
}

resource "azurerm_network_interface" "server" {
  name                = "server-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.server_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "examserverple" {
  name                = "server"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.server.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("ssh-keys/throwaway-key.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }
}