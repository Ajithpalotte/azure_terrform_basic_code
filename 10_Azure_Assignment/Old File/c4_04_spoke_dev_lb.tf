#  Public IP for Lb

resource "azurerm_public_ip" "spoke-dev-lbpublic-ip" {
  name                = "${local.spoke_dev_resource_name_prefix}-lbpublicip"
  resource_group_name = azurerm_resource_group.spokedevrg.name
  location            = azurerm_resource_group.spokedevrg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

#  Create LB 

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

# resource Backend address pool

resource "azurerm_lb_backend_address_pool" "spoke-dev-web_lb_backend_address_pool" {
  name            = "spoke-dev-web-backend"
  loadbalancer_id = azurerm_lb.spoke-dev-web-lb.id
}
# create Lb Prob

resource "azurerm_lb_probe" "spoke-dev-web_lb_prob" {
  name                = "tcp-prob"
  protocol            = "Tcp"
  port                = 80
  loadbalancer_id     = azurerm_lb.spoke-dev-web-lb.id
  resource_group_name = azurerm_resource_group.spokedevrg.name
}

# Create Lb rule

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


# Associate NIC (VM) & LB

resource "azurerm_network_interface_backend_address_pool_association" "spoke-dev-web_nic_lb_associate" {
  count                   = var.spoke-dev-vm-instance-count
  network_interface_id    = element(azurerm_network_interface.spoke-dev-appvm-nic-interface[*].id, count.index)
  ip_configuration_name   = azurerm_network_interface.spoke-dev-appvm-nic-interface[count.index].ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.spoke-dev-web_lb_backend_address_pool.id
}