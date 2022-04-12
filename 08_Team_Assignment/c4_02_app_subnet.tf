# app windows Subnet

resource "azurerm_subnet" "app-win-subnet" {
  name = "${local.resource_name_prefix}-${var.app_windows_vm_subnet_name}"
  resource_group_name = azurerm_resource_group.RG1.name
  virtual_network_name = azurerm_virtual_network.app-vlan.name
  address_prefixes = var.app_windows_vm_address_space
}

# app linux Subnet

resource "azurerm_subnet" "app-linux-subnet" {
  name = "${local.resource_name_prefix}-${var.app_linux_vm_subnet_name}"
  resource_group_name = azurerm_resource_group.RG1.name
  virtual_network_name = azurerm_virtual_network.app-vlan.name
  address_prefixes = var.app_linux_vm_address_space
}