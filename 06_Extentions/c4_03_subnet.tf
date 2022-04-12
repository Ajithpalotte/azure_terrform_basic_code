# MGMT subnet

resource "azurerm_subnet" "mgmt_subnet" {
  name                 = "${local.resource_name_prefix}-${var.mgmt_subnet_name}"
  resource_group_name  = azurerm_resource_group.RG1.name
  virtual_network_name = azurerm_virtual_network.mgmt_vnet.name
  address_prefixes     = var.mgmt_subnet_address
}

# app subnet creation

resource "azurerm_subnet" "app_subnet" {
  name                 = "${local.resource_name_prefix}-${var.app_subnet_name}"
  resource_group_name  = azurerm_resource_group.RG1.name
  virtual_network_name = azurerm_virtual_network.app_vnet.name
  address_prefixes     = var.app_subnet_address
}