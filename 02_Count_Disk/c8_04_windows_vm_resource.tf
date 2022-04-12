#custom data for installing IIS
/*
locals {
  windowsvm_iis_installation =<<CUSTOM_DATA
 Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools
  CUSTOM_DATA
}*/

resource "azurerm_windows_virtual_machine" "windowsvm" {

  name                  = "${local.winserver_name_prefix}${random_string.myrandom.id}" #max 15 characters
  resource_group_name   = azurerm_resource_group.myrg1.name
  location              = azurerm_resource_group.myrg1.location
  size                  = "Standard_F2"
  admin_username        = "adminaim"
  admin_password        = "Password@123"
  network_interface_ids = [azurerm_network_interface.windowsvm_nic_interface.id]
  os_disk {
    name                 = "${local.resource_name_prefix}-windows_vm-${random_string.myrandom.id}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  #custom_data = filebase64("${path.module}/webinstallation/iisinstall.ps1")
  #custom_data = base64encode(local.windowsvm_iis_installation)
}

resource "azurerm_managed_disk" "winvm_add_disk" {
  name                 = "${azurerm_windows_virtual_machine.windowsvm.name}-data_disk"
  location             = azurerm_resource_group.myrg1.location
  resource_group_name  = azurerm_resource_group.myrg1.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}
resource "azurerm_virtual_machine_data_disk_attachment" "attach_winvm_add_disk" {
  managed_disk_id    = azurerm_managed_disk.winvm_add_disk.id
  virtual_machine_id = azurerm_windows_virtual_machine.windowsvm.id
  lun                = "10"
  caching            = "ReadWrite"
}