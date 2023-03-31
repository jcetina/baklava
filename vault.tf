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
  ]

  secret_permissions = [
    "Set",
    "Delete",
    "Get",
    "Purge",
    "Recover",
  ]

}

resource "azurerm_key_vault_secret" "bastion_ssh_key" {
  provider     = azurerm.vault
  name         = "bastion-ssh-key-pem"
  value        = tls_private_key.servers-ssh-key.private_key_pem
  key_vault_id = azurerm_key_vault.vault.id
}

resource "azurerm_key_vault_secret" "bastion_ssh_key_openssh" {
  provider     = azurerm.vault
  name         = "bastion-ssh-key-pem-openssh"
  value        = tls_private_key.servers-ssh-key.private_key_openssh
  key_vault_id = azurerm_key_vault.vault.id
}

resource "tls_private_key" "servers-ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}