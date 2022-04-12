output "hub-resource-group" {
  value = azurerm_resource_group.hubrg.name
}
output "spokedev-resource-group" {
  value = azurerm_resource_group.spokedevrg.name
}
output "spokeprod-resource-group" {
  value = azurerm_resource_group.spokeprodrg.name
}

output "hub-valn-name" {
  value = azurerm_virtual_network.hub-vlan.name
}
output "hub-subnet-name" {
  value = azurerm_subnet.hub-subnet.name
}


output "spokedev-valn-name" {
  value = azurerm_virtual_network.spoke-dev-vlan.name
}
output "spokeprod-valn-name" {
  value = azurerm_virtual_network.spoke-prod-vlan.name
}
output "spokedev-subnet-name" {
  value = azurerm_subnet.spokedev-subnet.name
}


output "spokedev-nsg" {
  value = azurerm_network_security_group.spoke-dev-nsg.name
}






