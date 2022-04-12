# Resource-1 : Creating public ip for linux Vm

resource "azurerm_public_ip" "linuxvm_public_ip_address" {
  count               = var.linuxvm_instance_count
  name                = "${local.resource_name_prefix}-${var.linux_public_ip_name}-${count.index}"
  resource_group_name = azurerm_resource_group.myrg1.name
  location            = azurerm_resource_group.myrg1.location
  allocation_method   = "Static"
}



