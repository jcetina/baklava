data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = "org-jcetina-repo-baklava-rg"
}
