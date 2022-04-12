# Create network interface for mgmt VM
resource "azurerm_network_interface" "mgmt_vm_nic_interface" {
  name                = "${local.resource_name_prefix}-mgmtvm-nic"
  resource_group_name = azurerm_resource_group.RG1.name
  location            = azurerm_resource_group.RG1.location
  ip_configuration {
    name                          = "mgmt_vm_nic"
    subnet_id                     = azurerm_subnet.mgmt_subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id =           azurerm_public_ip.mgmtvm_public_ip_address.id
  }
}

# Create network interface for app VM
resource "azurerm_network_interface" "app_vm_nic_interface" {
  name                = "${local.resource_name_prefix}-appvm-nic"
  resource_group_name = azurerm_resource_group.RG1.name
  location            = azurerm_resource_group.RG1.location
  ip_configuration {
    name                          = "app_vm_nic"
    subnet_id                     = azurerm_subnet.app_subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.appvm_public_ip_address.id
  }

}