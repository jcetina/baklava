output "route_table_id" {
  description = "The ID of the route table."
  value       = module.route_table.id
}

output "vnet_id" {
  description = "The ID of the vnet."
  value       = azurerm_virtual_network.vnet.id
}

output "firewall_id" {
  description = "The ID of the firewall."
  value       = module.firewall.id
}

var "policy_id" {
  description = "The ID of the firewall policy."
  value       = azurerm_firewall_policy.policy.id
}