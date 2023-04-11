locals {
  address_manager = {
    "eastus" = {
      address_space = ["10.0.0.0/16"],
      subnet_layout = [
        {
          name    = "GatewaySubnet"
          newbits = 12
        },
        {
          name    = "ServerSubnet"
          newbits = 8
        }
      ]
    },
    "westus" = {
      address_space = ["10.1.0.0/16"],
      subnet_layout = [
        {
          name    = "GatewaySubnet"
          newbits = 12
        },
        {
          name    = "ServerSubnet"
          newbits = 8
        }
      ]
    }
  }

  subnets = {for k, v in local.address_manager : k => zipmap([for o in v.subnet_layout : o.name], cidrsubnets(v.address_space[0], [for o in v.subnet_layout : o.newbits]...))}

}


module "eastus" {
  for_each = local.subnets
  source = "./modules/azure-internal"
  vnet_location = each.key
  vnet_rg = data.azurerm_resource_group.rg.name
  cidr = local.address_manager[each.key].address_space
  gateway_subnet_prefixes = [each.value["GatewaySubnet"]]
}