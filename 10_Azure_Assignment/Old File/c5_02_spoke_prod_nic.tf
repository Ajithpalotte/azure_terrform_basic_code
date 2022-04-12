# Create network interface for spoke prod web server 1

resource "azurerm_network_interface" "spoke-prod-nic" {
  count               = var.spoke-prod-vm-instance-count
  name                = "${local.spoke_prod_resource_name_prefix}-app1-nic-${count.index}"
  location            = azurerm_resource_group.spokeprodrg.location
  resource_group_name = azurerm_resource_group.spokeprodrg.name
  ip_configuration {
    name                          = "prodapp_vm_ip_1"
    subnet_id                     = azurerm_subnet.spokeprod-subnet.id
    private_ip_address_allocation = "dynamic"

  }
}

