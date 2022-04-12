# hub Subnet

resource "azurerm_subnet" "hub-subnet" {
  name                 = "${local.hub_resource_name_prefix}-${var.hub_subnet_name}"
  resource_group_name  = azurerm_resource_group.hubrg.name
  virtual_network_name = azurerm_virtual_network.hub-vlan.name
  address_prefixes     = var.hub_subnet_address_space

}


resource "azurerm_public_ip" "hub-public-ip" {
  name                = "hub-public-ip"
  resource_group_name = azurerm_resource_group.hubrg.name
  location            = azurerm_resource_group.hubrg.location
  allocation_method   = "Dynamic"

}