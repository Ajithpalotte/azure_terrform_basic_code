# resource 1 : creating Subnet for Windows servers

resource "azurerm_subnet" "windows_subnet" {
  name                 = "${local.resource_name_prefix}-${var.windows_subnet_name}"
  resource_group_name  = azurerm_resource_group.myrg1.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.windows_subnet_address
}