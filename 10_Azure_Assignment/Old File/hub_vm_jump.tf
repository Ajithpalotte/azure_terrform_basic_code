# Create network interface for spoke dev web server 1

resource "azurerm_network_interface" "hub-jump-vm-nic-interface" {

  name                = "hub-jump-vm-nic-interface-app1-nic"
  location            = azurerm_resource_group.hubrg.location
  resource_group_name = azurerm_resource_group.hubrg.name
  ip_configuration {
    name                          = "hub-jump-vm-ip-1"
    subnet_id                     = azurerm_subnet.hub-subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.hub-public-ip.id

  }
}




resource "azurerm_windows_virtual_machine" "hub-jump-vm" {
  name                  = "hub-jump-vm" #max 15 characters
  resource_group_name   = azurerm_resource_group.hubrg.name
  location              = azurerm_resource_group.hubrg.location
  size                  = "Standard_F2"
  admin_username        = "adminaim"
  admin_password        = "Password@123"
  network_interface_ids = [azurerm_network_interface.hub-jump-vm-nic-interface.id]
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