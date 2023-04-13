module "eastus2-firewall" {
  source     = "./modules/firewall"
  fw_name    = "eastus2-firewall"
  location   = "eastus2"
  rg_name    = data.azurerm_resource_group.rg.name
  subnet_id  = module.sites["eastus2"].firewall_subnet_id
  zones      = ["1", "2", "3"]
  breakglass = false
}