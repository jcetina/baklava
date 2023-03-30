data "azurerm_resource_group" "rg" {
  name = "org-jcetina-repo-baklava-rg"
}

locals {
  vnet_name     = "my-secure-vnet"
  location      = "eastus"
  address_space = ["10.0.0.0/16"]

  address_manager = {
    "AzureFirewallSubnet" = {
      newbits = 8
    }
  }

  listified_address_manager = [for k, v in local.address_manager : { name = k, newbits = v.newbits }]

  subnets = zipmap([for o in local.listified_address_manager : o.name], cidrsubnets(local.address_space[0], [for o in local.listified_address_manager : o.newbits]...))
}

module "vnet" {
  source               = "./modules/vnet"
  name                 = local.vnet_name
  location             = local.location
  address_space        = local.address_space
  resource_group_name  = data.azurerm_resource_group.rg.name
  firewall_subnet      = [local.subnets["AzureFirewallSubnet"]]
  firewall_name        = "my-secure-firewall"
  nat_gateway_name     = "my-secure-nat-gw"
  nat_gateway_ip_count = 1
  nat_gw_idle_timeout  = 4
}