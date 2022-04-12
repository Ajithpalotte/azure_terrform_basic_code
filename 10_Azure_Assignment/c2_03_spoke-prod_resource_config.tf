#------------------------------------------------#
# create a network security group for spoke prod
#------------------------------------------------#
resource "azurerm_network_security_group" "spoke-prod-nsg" {
  name                = "${local.spoke_prod_resource_name_prefix}-spoke-nsg"
  resource_group_name = azurerm_resource_group.spokeprodrg.name
  location            = azurerm_resource_group.spokeprodrg.location
}

#----------------------------------------------#
# Create NSG rule for spoke prod
#----------------------------------------------#
locals {
  windows_prod_port_number = {
    "110" : "80",
    "120" : "443"
    "130" : "3389"
  }
}

resource "azurerm_network_security_rule" "spoke-prod-nsg-rule-inbound" {
  for_each                    = local.windows_prod_port_number
  name                        = "spokeprodnsgrule-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.spokeprodrg.name
  network_security_group_name = azurerm_network_security_group.spoke-prod-nsg.name

}
#----------------------------------------------#
# Associate NSG to spoke prod subnet
#----------------------------------------------#
resource "azurerm_subnet_network_security_group_association" "spoke-prod-vmnic-nsg" {
  depends_on                = [azurerm_network_security_rule.spoke-prod-nsg-rule-inbound]
  subnet_id                 = azurerm_subnet.spokeprod-subnet.id
  network_security_group_id = azurerm_network_security_group.spoke-prod-nsg.id
}

#-----------------------------------------------#
# Create network interface for spoke prod VMs
#-----------------------------------------------#
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

#-----------------------------------------------#
# VM creation for spoke prod using count.
#-----------------------------------------------#

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

#-----------------------------------------------#
# Install Extensions for VMs
#-----------------------------------------------#

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

#-----------------------------------------------#
#  Public IP for Spoke prod LB
#-----------------------------------------------#

resource "azurerm_public_ip" "spoke-prod-lbpublic-ip" {
  name                = "${local.spoke_prod_resource_name_prefix}-lbpublicip"
  resource_group_name = azurerm_resource_group.spokeprodrg.name
  location            = azurerm_resource_group.spokeprodrg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

#-----------------------------------------------#
#  Create LB for spoke prod
#-----------------------------------------------#

resource "azurerm_lb" "spoke-prod-web-lb" {
  name                = "${local.spoke_prod_resource_name_prefix}-web-lb"
  resource_group_name = azurerm_resource_group.spokeprodrg.name
  location            = azurerm_resource_group.spokeprodrg.location
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "spoke-prod-web-lb-public-ip-1"
    public_ip_address_id = azurerm_public_ip.spoke-prod-lbpublic-ip.id
  }
}

#-----------------------------------------------#
# Spoke prod LB resource Backend address pool
#-----------------------------------------------#

resource "azurerm_lb_backend_address_pool" "spoke-prod-web_lb_backend_address_pool" {
  name            = "spoke-prod-web-backend"
  loadbalancer_id = azurerm_lb.spoke-prod-web-lb.id
}

#-----------------------------------------------#
# create Lb Prob for spoke prod LB
#-----------------------------------------------#

resource "azurerm_lb_probe" "spoke-prod-web_lb_prob" {
  name                = "tcp-prob"
  protocol            = "Tcp"
  port                = 80
  loadbalancer_id     = azurerm_lb.spoke-prod-web-lb.id
  resource_group_name = azurerm_resource_group.spokeprodrg.name
}

#-----------------------------------------------#
# Create Lb rule for spoke prod LB
#-----------------------------------------------#

resource "azurerm_lb_rule" "spoke-prod-web_lb_rule" {
  name                           = "spoke-dev-web_lb_rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.spoke-prod-web-lb.frontend_ip_configuration[0].name
  backend_address_pool_id        = azurerm_lb_backend_address_pool.spoke-prod-web_lb_backend_address_pool.id
  probe_id                       = azurerm_lb_probe.spoke-prod-web_lb_prob.id
  loadbalancer_id                = azurerm_lb.spoke-prod-web-lb.id
  resource_group_name            = azurerm_resource_group.spokeprodrg.name
}

#--------------------------------------------------#
# Associate spoke dev VMs NIC (VM) & spoke prod LB
#--------------------------------------------------#

resource "azurerm_network_interface_backend_address_pool_association" "spoke-prod-web_nic_lb_associate" {
  count                   = var.spoke-prod-vm-instance-count
  network_interface_id    = element(azurerm_network_interface.spoke-prod-nic[*].id, count.index)
  ip_configuration_name   = azurerm_network_interface.spoke-prod-nic[count.index].ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.spoke-prod-web_lb_backend_address_pool.id
} 







