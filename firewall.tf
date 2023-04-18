module "eastus2-firewall" {
  source                         = "./modules/firewall"
  fw_name                        = "eastus2-firewall"
  location                       = "eastus2"
  rg_name                        = data.azurerm_resource_group.rg.name
  subnet_id                      = module.sites["eastus2"].firewall_subnet_id
  zones                          = ["1", "2", "3"]
  breakglass                     = false
  user_allowed_application_rules = local.user_allowed_application_rules
  user_allowed_network_rules     = local.user_allowed_network_rules
}

locals {
  user_allowed_application_rules = [
    {
      name              = "AllowGoogleDotCom"
      protocols         = [{ type = "Https", port = 443 }]
      source_addresses  = ["*"]
      destination_fqdns = ["*.google.com", "google.com"]
    },
    {
      name              = "AllowMicrosoftDotCom"
      protocols         = [{ type = "Https", port = 443 }]
      source_addresses  = ["*"]
      destination_fqdns = ["*.microsoft.com", "microsoft.com"]
    }
  ]

  user_allowed_network_rules = [
    {
      name                  = "AllowAll"
      protocols             = ["Any"]
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["*"]
    }
  ]
}