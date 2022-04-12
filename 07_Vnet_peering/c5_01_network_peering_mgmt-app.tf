

# mgmt to app

resource "azurerm_virtual_network_peering" "mgmt-app-peering" {
  name                      = "${local.resource_name_prefix}-mgmt-app-peering"
  resource_group_name       = azurerm_resource_group.RG1.name
  virtual_network_name      = azurerm_virtual_network.mgmt_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.app_vnet.id
}

# app to mgmt
resource "azurerm_virtual_network_peering" "app-mgmt-peering" {
  name                      = "${local.resource_name_prefix}-app-mgmt-peering"
  resource_group_name       = azurerm_resource_group.RG1.name
  virtual_network_name      = azurerm_virtual_network.app_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.mgmt_vnet.id
}




