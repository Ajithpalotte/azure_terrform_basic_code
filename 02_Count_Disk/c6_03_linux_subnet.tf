# resource 1 : creating Subnet for Linux servers

resource "azurerm_subnet" "linux_subnet" {
  name                 = "${local.resource_name_prefix}-${var.linux_subnet_name}"
  resource_group_name  = azurerm_resource_group.myrg1.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.linux_subnet_address
}