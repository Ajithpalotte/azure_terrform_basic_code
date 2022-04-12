# resource 1: Public IP for Lb

resource "azurerm_public_ip" "web_lbpublicip" {
  name                = "${local.resource_name_prefix}-lbpublicip"
  resource_group_name = azurerm_resource_group.myrg1.name
  location            = azurerm_resource_group.myrg1.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Resource 2 : Create LB 

resource "azurerm_lb" "web_lb" {
  name                = "${local.resource_name_prefix}-web-lb"
  resource_group_name = azurerm_resource_group.myrg1.name
  location            = azurerm_resource_group.myrg1.location
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "web-lb-public-ip-1"
    public_ip_address_id = azurerm_public_ip.web_lbpublicip.id
  }
}

# resource Backend address pool

resource "azurerm_lb_backend_address_pool" "web_lb_backend_address_pool" {
  name            = "web-backend"
  loadbalancer_id = azurerm_lb.web_lb.id
}

# create Lb Prob

resource "azurerm_lb_probe" "web_lb_prob" {
  name                = "tcp-prob"
  protocol            = "Tcp"
  port                = 80
  loadbalancer_id     = azurerm_lb.web_lb.id
  resource_group_name = azurerm_resource_group.myrg1.name
}

# Create Lb rule

resource "azurerm_lb_rule" "web_lb_rule_app1" {
  name                           = "web-app1-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.web_lb.frontend_ip_configuration[0].name
  backend_address_pool_id       = azurerm_lb_backend_address_pool.web_lb_backend_address_pool.id
  probe_id                       = azurerm_lb_probe.web_lb_prob.id
  loadbalancer_id                = azurerm_lb.web_lb.id
  resource_group_name            = azurerm_resource_group.myrg1.name
}

# Associate NIC (VM) & LB

resource "azurerm_network_interface_backend_address_pool_association" "web_nic_lb_associate" {
 count=var.linuxvm_instance_count
  network_interface_id    = [element(azurerm_network_interface.linuxvm_nic_interface[*].id, count.index)]
  #azurerm_network_interface.linuxvm_nic_interface.id
  
  ip_configuration_name   = [element(azurerm_network_interface.linuxvm_nic_interface.ip_configuration[0][*].name, count.index)]
  backend_address_pool_id = azurerm_lb_backend_address_pool.web_lb_backend_address_pool.id
}

