#------------------------------------------------#
# create a network security group for spoke dev.
#------------------------------------------------#
resource "azurerm_network_security_group" "spoke-dev-nsg" {
  name                = "${local.spoke_dev_resource_name_prefix}-spoke-nsg"
  resource_group_name = azurerm_resource_group.spokedevrg.name
  location            = azurerm_resource_group.spokedevrg.location
}

#-----------------------------------------------#
# Create NSG rule for spoke dev.
#-----------------------------------------------#
locals {
  windows_port_number = {
    "110" : "80",
    "120" : "443"
    "130" : "3389"
  }
}

resource "azurerm_network_security_rule" "spoke-dev-nsg-rule-inbound" {
  for_each                    = local.windows_port_number
  name                        = "spokedevnsgrule-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.spokedevrg.name
  network_security_group_name = azurerm_network_security_group.spoke-dev-nsg.name

}

#-----------------------------------------------#
# Associate spoke dev NSG to spoke dev subnet
#-----------------------------------------------#
resource "azurerm_subnet_network_security_group_association" "spoke-dev-vmnic-nsg" {
  depends_on                = [azurerm_network_security_rule.spoke-dev-nsg-rule-inbound]
  subnet_id                 = azurerm_subnet.spokedev-subnet.id
  network_security_group_id = azurerm_network_security_group.spoke-dev-nsg.id
}

#-----------------------------------------------#
# Create network interface for spoke dev VMs
#-----------------------------------------------#

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

#-----------------------------------------------#
# VM creation for spoke dev using count.
#-----------------------------------------------#


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

#-----------------------------------------------#
# Install Extensions for VMs
#-----------------------------------------------#

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


#-----------------------------------------------#
#  Public IP for Spoke Dev LB
#-----------------------------------------------#

resource "azurerm_public_ip" "spoke-dev-lbpublic-ip" {
  name                = "${local.spoke_dev_resource_name_prefix}-lbpublicip"
  resource_group_name = azurerm_resource_group.spokedevrg.name
  location            = azurerm_resource_group.spokedevrg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

#-----------------------------------------------#
#  Create LB for spoke dev
#-----------------------------------------------#

resource "azurerm_lb" "spoke-dev-web-lb" {
  name                = "${local.spoke_dev_resource_name_prefix}-web-lb"
  resource_group_name = azurerm_resource_group.spokedevrg.name
  location            = azurerm_resource_group.spokedevrg.location
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "spoke-dev-web-lb-public-ip-1"
    public_ip_address_id = azurerm_public_ip.spoke-dev-lbpublic-ip.id
  }
}

#-----------------------------------------------#
# Spoke dev LB resource Backend address pool
#-----------------------------------------------#

resource "azurerm_lb_backend_address_pool" "spoke-dev-web_lb_backend_address_pool" {
  name            = "spoke-dev-web-backend"
  loadbalancer_id = azurerm_lb.spoke-dev-web-lb.id
}

#-----------------------------------------------#
# create Lb Prob for spoke dev LB
#-----------------------------------------------#

resource "azurerm_lb_probe" "spoke-dev-web_lb_prob" {
  name                = "tcp-prob"
  protocol            = "Tcp"
  port                = 80
  loadbalancer_id     = azurerm_lb.spoke-dev-web-lb.id
  resource_group_name = azurerm_resource_group.spokedevrg.name
}

#-----------------------------------------------#
# Create Lb rule for spoke dev LB
#-----------------------------------------------#

resource "azurerm_lb_rule" "spoke-dev-web_lb_rule" {
  name                           = "spoke-dev-web_lb_rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.spoke-dev-web-lb.frontend_ip_configuration[0].name
  backend_address_pool_id        = azurerm_lb_backend_address_pool.spoke-dev-web_lb_backend_address_pool.id
  probe_id                       = azurerm_lb_probe.spoke-dev-web_lb_prob.id
  loadbalancer_id                = azurerm_lb.spoke-dev-web-lb.id
  resource_group_name            = azurerm_resource_group.spokedevrg.name
}

#-------------------------------------------------#
# Associate spoke dev VMs NIC (VM) & spoke dev LB
#-------------------------------------------------#

resource "azurerm_network_interface_backend_address_pool_association" "spoke-dev-web_nic_lb_associate" {
  count                   = var.spoke-dev-vm-instance-count
  network_interface_id    = element(azurerm_network_interface.spoke-dev-appvm-nic-interface[*].id, count.index)
  ip_configuration_name   = azurerm_network_interface.spoke-dev-appvm-nic-interface[count.index].ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.spoke-dev-web_lb_backend_address_pool.id
}





