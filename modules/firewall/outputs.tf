output "id" {
  description = "The ID of firewall."
  value       = azurerm_firewall.firewall.id
}

output "public_ip" {
  description = "The public IP address of the firewall."
  value       = module.ip.public_ip
}

output "private_ip" {
  description = "The private IP address of the firewall."
  value       = azurerm_firewall.firewall.ip_configuration[0].private_ip_address
}