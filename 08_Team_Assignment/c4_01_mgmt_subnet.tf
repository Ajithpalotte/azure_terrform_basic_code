# Mgmt windows Subnet

resource "azurerm_subnet" "mgmt-win-subnet" {
  name = "${local.resource_name_prefix}-${var.mgmt_windows_vm_subnet_name}"
  resource_group_name = azurerm_resource_group.RG1.name
  virtual_network_name = azurerm_virtual_network.mgmt-vlan.name
  address_prefixes = var.mgmt_windows_vm_address_space
}

# Mgmt linux Subnet

resource "azurerm_subnet" "mgmt-linux-subnet" {
  name = "${local.resource_name_prefix}-${var.mgmt_linux_vm_subnet_name}"
  resource_group_name = azurerm_resource_group.RG1.name
  virtual_network_name = azurerm_virtual_network.mgmt-vlan.name
  address_prefixes = var.mgmt_linux_vm_subnet_name
}