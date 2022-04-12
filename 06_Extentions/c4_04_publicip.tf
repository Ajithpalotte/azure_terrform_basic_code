# Resource-1 : Creating public ip for mgmt Vm

resource "azurerm_public_ip" "mgmtvm_public_ip_address" {
  name                = "${local.resource_name_prefix}-mgmtvm-public-ip"
  resource_group_name = azurerm_resource_group.RG1.name
  location            = azurerm_resource_group.RG1.location
  allocation_method   = "Static"
}

# Resource-1 : Creating public ip for app Vm

resource "azurerm_public_ip" "appvm_public_ip_address" {
  name                = "${local.resource_name_prefix}-appvm-public-ip"
  resource_group_name = azurerm_resource_group.RG1.name
  location            = azurerm_resource_group.RG1.location
  allocation_method   = "Static"
}