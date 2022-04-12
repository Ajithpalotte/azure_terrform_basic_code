# create MGMT network
resource "azurerm_virtual_network" "mgmt-vlan" {
  name = "${local.resource_name_prefix}-${var.mgmt_vlan_name}"
  location = azurerm_resource_group.RG1.location
  resource_group_name = azurerm_resource_group.RG1.name
  address_space = var.mgmt_vlan_address_space
  tags = local.project_tags
}

# create application network
resource "azurerm_virtual_network" "app-vlan" {
  name = "${local.resource_name_prefix}-${var.app_vlan_name}"
  location = azurerm_resource_group.RG1.location
  resource_group_name = azurerm_resource_group.RG1.name
  address_space = var.app_vlan_address_space
  tags = local.project_tags
}

