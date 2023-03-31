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

resource "azurerm_network_interface" "servers" {
  name                = "server-nic-${count.index}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.server_subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  count = 2
}

resource "azurerm_linux_virtual_machine" "servers" {
  name                = "server-${count.index}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.servers[count.index].id,
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
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  count = 2
}

resource "azurerm_firewall_application_rule_collection" "server_app_rule_collection" {
  name                = "server_app_rule_collection"
  azure_firewall_name = module.vnet.firewall_name
  resource_group_name = data.azurerm_resource_group.rg.name
  priority            = 101
  action              = "Allow"

  rule {
    name = "google"

    source_addresses = local.address_space

    target_fqdns = [
      "*.google.com",
      "google.com"
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }

  rule {
    name = "github"

    source_addresses = local.address_space

    target_fqdns = [
      "*.github.com",
      "github.com"
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }
}