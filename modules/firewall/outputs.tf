output "firewall_public_ip" {
  description = "The public IP address of the firewall."
  value       = azurerm_public_ip.firewall_ip.ip_address
}

output "firewall_private_ip" {
  description = "The public IP address of the firewall."
  value       = azurerm_firewall.firewall.ip_configuration[0].private_ip_address
}