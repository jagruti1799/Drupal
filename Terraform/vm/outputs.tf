output "public_ip_address" {
  description = "Virtual machine ids created."
  value       = azurerm_public_ip.publicip.*.ip_address
}