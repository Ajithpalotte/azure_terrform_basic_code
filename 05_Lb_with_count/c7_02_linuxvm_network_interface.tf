# Create network interface for linux VM

resource "azurerm_network_interface" "linuxvm_nic_interface" {
  count               = var.linuxvm_instance_count
  name                = "${local.resource_name_prefix}-linuxvm_nic-${count.index}"
  location            = azurerm_resource_group.myrg1.location
  resource_group_name = azurerm_resource_group.myrg1.name
  ip_configuration {
    name                          = "linuxvm_ip_1"
    subnet_id                     = azurerm_subnet.linux_subnet.id
    private_ip_address_allocation = "dynamic"
    #public_ip_address_id          = element(azurerm_public_ip.linuxvm_public_ip_address[*].id, count.index) #splat expression
  }
}