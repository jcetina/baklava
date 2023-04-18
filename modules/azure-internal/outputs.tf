output "gateway_subnet_id" {
  description = "The ID of the gateway subnet."
  value       = azurerm_subnet.gateway.id
}

output "vm_subnet_id" {
  description = "The ID of the vm subnet."
  value       = azurerm_subnet.vm.id
}

output "vnet_gateway_id" {
  description = "The ID of the vnet gateway."
  value       = azurerm_virtual_network_gateway.gateway.id
}

output "firewall_subnet_id" {
  description = "The ID of the route table."
  value       = azurerm_subnet.firewall.id
}