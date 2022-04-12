# Create network interface for spoke dev web server 1

resource "azurerm_network_interface" "spoke-dev-appvm-nic-interface" {
  count               = var.spoke-dev-vm-instance-count
  name                = "${local.spoke_dev_resource_name_prefix}-app1-nic-${count.index}"
  location            = azurerm_resource_group.spokedevrg.location
  resource_group_name = azurerm_resource_group.spokedevrg.name
  ip_configuration {
    name                          = "app1_vm_ip_1"
    subnet_id                     = azurerm_subnet.spokedev-subnet.id
    private_ip_address_allocation = "dynamic"

  }
}

