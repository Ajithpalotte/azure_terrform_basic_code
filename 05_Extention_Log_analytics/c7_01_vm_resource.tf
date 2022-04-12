#  mgmt VM Configuration

resource "azurerm_linux_virtual_machine" "mgmtvm" {
  name                            = "${local.resource_name_prefix}-mgmt-vm"
  resource_group_name             = azurerm_resource_group.RG1.name
  location                        = azurerm_resource_group.RG1.location
  size                            = "Standard_DS1_v2"
  admin_username                  = "azureuser"
  admin_password                  = "root@123"
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.mgmt_vm_nic_interface.id]
  /* admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-key/terraform-azure.pub")
    
  
  } */

  os_disk {
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
/*
#  app  VM Configuration

resource "azurerm_linux_virtual_machine" "appvm" {
  name                            = "${local.resource_name_prefix}-app-vm"
  resource_group_name             = azurerm_resource_group.RG1.name
  location                        = azurerm_resource_group.RG1.location
  size                            = "Standard_DS1_v2"
  admin_username                  = "azureuser"
  admin_password                  = "root@123"
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.app_vm_nic_interface.id]
  /* admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-key/terraform-azure.pub")
  } */
/*
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "83-gen2"
    version   = "latest"
  }

} */

#  app  Win-VM Configuration

resource "azurerm_windows_virtual_machine" "windowsvm" {

  name                = "${local.resource_name_prefix}-winvm"
  resource_group_name = azurerm_resource_group.RG1.name
  location            = azurerm_resource_group.RG1.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  admin_password      = "root@12345"

  network_interface_ids = [azurerm_network_interface.app_vm_nic_interface.id]
  os_disk {

    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

}