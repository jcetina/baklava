locals {
  vnet_name     = "my-secure-vnet"
  location      = "eastus"
  address_space = ["10.0.0.0/16"]

  address_manager = [
    {
      name    = "AzureFirewallSubnet"
      newbits = 8
    },
    {
      name    = "ServerSubnet"
      newbits = 8
    },
    {
      name    = "AzureBastionSubnet"
      newbits = 8
    }
  ]

  subnets = zipmap([for o in local.address_manager : o.name], cidrsubnets(local.address_space[0], [for o in local.address_manager : o.newbits]...))
}

