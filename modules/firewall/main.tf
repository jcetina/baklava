resource "azurerm_firewall" "firewall" {
  name                = var.fw_name
  location            = var.location
  resource_group_name = var.rg_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  zones               = var.zones
  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.firewall_ip.id
  }
}

resource "azurerm_public_ip" "firewall_ip" {
  name                = "${var.fw_name}-pip"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.zones
}

resource "azurerm_firewall_policy" "policy" {
  name                = "${var.fw_name}-policy"
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_firewall_policy_rule_collection_group" "breakglass" {
  count              = var.breakglass ? 1 : 0
  name               = "${azurerm_firewall_policy.policy.name}-rcg-breakglass"
  firewall_policy_id = azurerm_firewall_policy.policy.id
  priority           = 100

  network_rule_collection {
    name     = "breakglass"
    priority = 100
    action   = "Allow"
    rule {
      name                  = "AllowAll"
      protocols             = ["Any"]
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["1-65535"]
    }
  }

}

resource "azurerm_firewall_policy_rule_collection_group" "user_rule_collection" {
  count              = length(var.user_allowed_network_rules) + length(var.user_allowed_application_rules) > 0 ? 1 : 0
  name               = "${azurerm_firewall_policy.policy.name}-rcg-user-app-rules"
  firewall_policy_id = azurerm_firewall_policy.policy.id
  priority           = 500

  dynamic "application_rule_collection" {
    for_each = length(var.user_allowed_application_rules) > 0 ? ["create"] : []
    content {
      name     = "user_allowed_application_rules"
      priority = 100
      action   = "Allow"
      dynamic "rule" {
        for_each = var.user_allowed_application_rules
        content {
          name              = rule.value.name
          source_addresses  = rule.value.source_addresses
          destination_fqdns = rule.value.destination_fqdns
          dynamic "protocols" {
            for_each = rule.value.protocols
            content {
              type = protocols.value.type
              port = protocols.value.port
            }
          }
        }
      }
    }
  }

  dynamic "application_rule_collection" {
    for_each = length(var.user_allowed_network_rules) > 0 ? ["create"] : []
    content {
      name     = "user_allowed_network_rules"
      priority = 101
      action   = "Allow"
      dynamic "rule" {
        for_each = var.user_allowed_network_rules
        content {
          name                  = rule.value.name
          protocols             = rule.value.protocols
          source_addresses      = rule.value.source_addresses
          destination_addresses = rule.value.destination_addresses
          destination_ports     = rule.value.destination_ports
        }
      }
    }
  }
}