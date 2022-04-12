#Hub to spoke Dev

resource "azurerm_virtual_network_peering" "hub-spokedev-peering" {
  name                      = "hub-spoke-dev-peering"
  resource_group_name       = azurerm_resource_group.hubrg.name
  virtual_network_name      = azurerm_virtual_network.hub-vlan.name
  remote_virtual_network_id = azurerm_virtual_network.spoke-dev-vlan.id
}

# spoke Dev to Hub

resource "azurerm_virtual_network_peering" "spokedev-hub-peering" {
  name                      = "spoke-dev-hub-peering"
  resource_group_name       = azurerm_resource_group.spokedevrg.name
  virtual_network_name      = azurerm_virtual_network.spoke-dev-vlan.name
  remote_virtual_network_id = azurerm_virtual_network.hub-vlan.id
}


#Hub to spoke prod

resource "azurerm_virtual_network_peering" "hub-spokeprod-peering" {
  name                      = "hub-spoke-prod-peering"
  resource_group_name       = azurerm_resource_group.hubrg.name
  virtual_network_name      = azurerm_virtual_network.hub-vlan.name
  remote_virtual_network_id = azurerm_virtual_network.spoke-prod-vlan.id
}

# spoke prod to Hub

resource "azurerm_virtual_network_peering" "spokeprod-hub-peering" {
  name                      = "spoke-prod-hub-peering"
  resource_group_name       = azurerm_resource_group.spokeprodrg.name
  virtual_network_name      = azurerm_virtual_network.spoke-prod-vlan.name
  remote_virtual_network_id = azurerm_virtual_network.hub-vlan.id
}