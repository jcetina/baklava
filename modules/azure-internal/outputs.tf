output "gateway_subnet_id" {
  description = "The ID of the route table."
  value       = azurerm_subnet.gateway.id
}

output "vm_subnet_id" {
  description = "The ID of the route table."
  value       = azurerm_subnet.vm.id
}

output "gateway_id" {
  description = "The ID of the route table."
  value       = azurerm_virtual_network_gateway.gateway.id
}