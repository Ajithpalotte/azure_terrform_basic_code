# create a network security group.
resource "azurerm_network_security_group" "linux_vmnic_nsg" {
    name = "${azurerm_network_interface.linuxvm_nic_interface.name}-nsg"
    resource_group_name = azurerm_resource_group.myrg1.name
    location = azurerm_resource_group.myrg1.location
}

# Associate NSG to linux VM NIC
resource "azurerm_network_interface_security_group_association" "linux_vmnic_nsg" {
  depends_on = [azurerm_network_security_rule.linux_nsg_rule_inbound]
  network_interface_id = azurerm_network_interface.linuxvm_nic_interface.id
  network_security_group_id = azurerm_network_security_group.linux_vmnic_nsg.id
}

# Create NSG rule.
#for port 22,80,443
# local block for for each to enable security rule
locals{
    linux_port_number = {
        "100" : "22",
        "110" : "80",
        "120" : "443"
    }
}

resource "azurerm_network_security_rule" "linux_nsg_rule_inbound" {
 for_each = local.linux_port_number
  name                        = "linuxnsgrule-${each.value}"
  priority                    = each.key    
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.myrg1.name
  network_security_group_name = azurerm_network_security_group.linux_vmnic_nsg.name
  
}