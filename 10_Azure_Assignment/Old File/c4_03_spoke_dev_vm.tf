resource "azurerm_windows_virtual_machine" "spokedev-app1-vm" {
  count                 = var.spoke-dev-vm-instance-count
  name                  = "spokedevvm-${count.index}" #max 15 characters
  resource_group_name   = azurerm_resource_group.spokedevrg.name
  location              = azurerm_resource_group.spokedevrg.location
  size                  = "Standard_F2"
  admin_username        = "adminaim"
  admin_password        = "Password@123"
  network_interface_ids = [element(azurerm_network_interface.spoke-dev-appvm-nic-interface[*].id, count.index)]
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
resource "azurerm_virtual_machine_extension" "install-iis" {
  count                = var.spoke-dev-vm-instance-count
  name                 = "iis-webserver"
  virtual_machine_id   = element(azurerm_windows_virtual_machine.spokedev-app1-vm[*].id, count.index)
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature"
    }
    SETTINGS
}

/*
resource "azurerm_virtual_machine_extension" "spokedev-app1-vm-ext" {
  name                 = "join-domain"
  virtual_machine_id   = element(azurerm_windows_virtual_machine.spokedev-app1-vm[*].id,count.index)
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "2.0"

  settings = <<SETTINGS
  {
        "Name": "corpdir.onmicrosoft.com",
        "OUPath": "",
        "User": "CSTX_a_AAJITH1@corpdir.onmicrosoft.com",
        "Restart": "true",
        "Options": "3"
  }
  SETTINGS
}
*/


