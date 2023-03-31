data "azurerm_resource_group" "rg" {
  name = "org-jcetina-repo-baklava-rg"
}

locals {
  vnet_name     = "my-secure-vnet"
  location      = "eastus"
  address_space = ["10.0.0.0/16"]

  address_manager = [
    {
      name = "AzureFirewallSubnet"
      newbits = 8
    },
    {
      name = "ServerSubnet"
      newbits = 8
    },
    {
      name = "AzureBastionSubnet"
      newbits = 8
    }
  ]

  subnets = zipmap([for o in local.address_manager : o.name], cidrsubnets(local.address_space[0], [for o in local.address_manager : o.newbits]...))
}

module "vnet" {
  source              = "./modules/vnet"
  name                = local.vnet_name
  location            = local.location
  address_space       = local.address_space
  resource_group_name = data.azurerm_resource_group.rg.name
  firewall_subnet     = [local.subnets["AzureFirewallSubnet"]]
  bastion_subnet      = [local.subnets["AzureBastionSubnet"]]
  firewall_name       = "my-secure-firewall"
  nat_gateway_name    = "my-secure-nat-gw"
  route_table_name    = "my-secure-route-table"
  policy_name         = "my-secure-policy"
  nat_gw_ip_count     = 1
  nat_gw_idle_timeout = 4
}