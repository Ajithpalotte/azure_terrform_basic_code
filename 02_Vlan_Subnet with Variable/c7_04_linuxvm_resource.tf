#  Linux VM Configuration

resource "azurerm_linux_virtual_machine" "linuxvm" {
  
    name = "${local.linuxserver_name_prefix}${random_string.myrandom.id}"
    #computer_name = "linux-vm"
    resource_group_name = azurerm_resource_group.myrg1.name
    location = azurerm_resource_group.myrg1.location
    size = "Standard_DS1_v2"
    admin_username = "azureuser"
    network_interface_ids = [ azurerm_network_interface.linuxvm_nic_interface.id ]
    admin_ssh_key {
      username = "azureuser"
      public_key = file("${path.module}/ssh-key/terraform-azure.pub")
    }
  os_disk {
    name = "${local.resource_name_prefix}-linux_vm-${random_string.myrandom.id}"  
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "RedHat"
    offer = "RHEL"
    sku = "83-gen2"
    version = "latest"
  }
}