locals {
  address_manager = {
    "eastus2" = {
      address_space = ["10.0.0.0/16"],
      subnet_layout = [
        {
          name    = "GatewaySubnet"
          newbits = 11
        },
        {
          name    = "VmSubnet"
          newbits = 8
        }
      ]
    },
    "westus2" = {
      address_space = ["10.1.0.0/16"],
      subnet_layout = [
        {
          name    = "GatewaySubnet"
          newbits = 11
        },
        {
          name    = "VmSubnet"
          newbits = 8
        }
      ]
    }
  }

  subnets = { for k, v in local.address_manager : k => zipmap([for o in v.subnet_layout : o.name], cidrsubnets(v.address_space[0], [for o in v.subnet_layout : o.newbits]...)) }

}


module "sites" {
  for_each                = local.subnets
  source                  = "./modules/azure-internal"
  vnet_location           = each.key
  rg_name                 = data.azurerm_resource_group.rg.name
  cidr                    = local.address_manager[each.key].address_space
  gateway_subnet_prefixes = [each.value["GatewaySubnet"]]
  vm_subnet_prefixes      = [each.value["VmSubnet"]]
}



resource "azurerm_virtual_network_gateway_connection" "east_west" {
  name                = "east-west-connection"
  location            = "eastus2"
  resource_group_name = data.azurerm_resource_group.rg.name

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = module.sites["eastus2"].gateway_id
  peer_virtual_network_gateway_id = module.sites["westus2"].gateway_id


  shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
}

resource "azurerm_virtual_network_gateway_connection" "west_east" {
  name                = "west-east-connection"
  location            = "westus2"
  resource_group_name = data.azurerm_resource_group.rg.name

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = module.sites["westus2"].gateway_id
  peer_virtual_network_gateway_id = module.sites["eastus2"].gateway_id


  shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
}

module "westus2-vms" {
  count            = 1
  source           = "./modules/vm"
  location         = "westus2"
  rg_name          = data.azurerm_resource_group.rg.name
  subnet_id        = module.sites["westus2"].vm_subnet_id
  vm_name          = "westus2-vm-${count.index}"
  ssh_key          = file("./ssh-keys/disposable-key.pub")
  create_public_ip = true
  zones            = ["1", "2", "3"]
}

module "eastus2-vms" {
  count            = 1
  source           = "./modules/vm"
  location         = "eastus2"
  rg_name          = data.azurerm_resource_group.rg.name
  subnet_id        = module.sites["eastus2"].vm_subnet_id
  vm_name          = "eastus2-vm-${count.index}"
  ssh_key          = file("./ssh-keys/disposable-key.pub")
  create_public_ip = true
  zones            = ["1", "2", "3"]
}