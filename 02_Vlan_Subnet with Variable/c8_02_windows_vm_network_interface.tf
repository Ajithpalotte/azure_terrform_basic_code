# Create network interface for windows VM

resource "azurerm_network_interface" "windowsvm_nic_interface" {
  name = "${local.resource_name_prefix}-windowsvm_nic"
  location = azurerm_resource_group.myrg1.location
  resource_group_name = azurerm_resource_group.myrg1.name
  ip_configuration {
    name = "windowsvm_ip_1"
    subnet_id = azurerm_subnet.windows_subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = azurerm_public_ip.windowsvm_public_ip_address.id
  }
}