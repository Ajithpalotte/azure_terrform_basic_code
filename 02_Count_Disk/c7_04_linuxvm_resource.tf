#  Linux VM Configuration

resource "azurerm_linux_virtual_machine" "linuxvm" {
  count = var.linuxvm_instance_count
  name  = "${local.linuxserver_name_prefix}-${count.index}"
  #computer_name = "linux-vm"
  resource_group_name   = azurerm_resource_group.myrg1.name
  location              = azurerm_resource_group.myrg1.location
  size                  = "Standard_DS1_v2"
  admin_username        = "azureuser"
  network_interface_ids = [element(azurerm_network_interface.linuxvm_nic_interface[*].id, count.index)]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-key/terraform-azure.pub")
  }

  os_disk {
    name                 = "${local.resource_name_prefix}-linux_vm-osdisk-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "83-gen2"
    version   = "latest"
  }
}

resource "azurerm_managed_disk" "linuxvm_add_disk" {
  count                = var.linuxvm_instance_count
  name                 = "${azurerm_linux_virtual_machine.linuxvm[count.index].name}-${count.index}"
  location             = azurerm_resource_group.myrg1.location
  resource_group_name  = azurerm_resource_group.myrg1.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}
resource "azurerm_virtual_machine_data_disk_attachment" "attach_linuxvm_add_disk" {
  count              = var.linuxvm_instance_count
  managed_disk_id    = azurerm_managed_disk.linuxvm_add_disk[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.linuxvm[count.index].id
  lun                = "10"
  caching            = "ReadWrite"
}