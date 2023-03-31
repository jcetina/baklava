locals {
  key_vault_suffix_seed = join(":", [data.azurerm_client_config.current.tenant_id, data.azurerm_client_config.current.subscription_id, data.azurerm_resource_group.rg.name])
  key_vault_suffix      = substr(sha1(local.key_vault_suffix_seed), 0, 8)
  key_vault_name        = "bastion-vault-${local.key_vault_suffix}"
}

resource "azurerm_key_vault" "vault" {
  provider                   = azurerm.vault
  name                       = local.key_vault_name
  location                   = data.azurerm_resource_group.rg.location
  resource_group_name        = data.azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "premium"
  soft_delete_retention_days = 7


}


resource "azurerm_key_vault_access_policy" "vault_access_policy" {
  provider     = azurerm.vault
  key_vault_id = azurerm_key_vault.vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Create",
    "Delete",
    "Get",
    "Purge",
    "Recover",
    "Update",
    "Get",
  ]

  secret_permissions = [
    "Set",
  ]
}

resource "azurerm_key_vault_key" "bastion_ssh_key" {
  provider     = azurerm.vault
  name         = "bastion-ssh-key"
  key_vault_id = azurerm_key_vault.vault.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "verify",
  ]
}