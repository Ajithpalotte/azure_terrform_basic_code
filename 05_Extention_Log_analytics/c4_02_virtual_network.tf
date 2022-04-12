# MGMT virtual Network

resource "azurerm_virtual_network" "mgmt_vnet" {
  name                = "${local.resource_name_prefix}-${var.vnet_mgmt}"
  location            = azurerm_resource_group.RG1.location
  resource_group_name = azurerm_resource_group.RG1.name
  address_space       = var.mgmtvnet_address_space
}


# app virtual Network

resource "azurerm_virtual_network" "app_vnet" {
  name                = "${local.resource_name_prefix}-${var.vnet_app}"
  location            = azurerm_resource_group.RG1.location
  resource_group_name = azurerm_resource_group.RG1.name
  address_space       = var.appvnet_address_space
}