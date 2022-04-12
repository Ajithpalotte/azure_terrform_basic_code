resource "azurerm_windows_virtual_machine" "spokeprod-app1-vm" {
  count                 = var.spoke-prod-vm-instance-count
  name                  = "spokeprodvm-${count.index}" #max 15 characters
  resource_group_name   = azurerm_resource_group.spokeprodrg.name
  location              = azurerm_resource_group.spokeprodrg.location
  size                  = "Standard_F2"
  admin_username        = "adminaim"
  admin_password        = "Password@123"
  network_interface_ids = [element(azurerm_network_interface.spoke-prod-nic[*].id, count.index)]
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
resource "azurerm_virtual_machine_extension" "install-iis-prod" {
  count                = var.spoke-prod-vm-instance-count
  name                 = "iis-webserver-prod"
  virtual_machine_id   = element(azurerm_windows_virtual_machine.spokeprod-app1-vm[*].id, count.index)
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature"
    }
    SETTINGS
}




