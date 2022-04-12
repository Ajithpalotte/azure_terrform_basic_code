#  Public IP for Lb

resource "azurerm_public_ip" "spoke-prod-lbpublic-ip" {
  name                = "${local.spoke_prod_resource_name_prefix}-lbpublicip"
  resource_group_name = azurerm_resource_group.spokeprodrg.name
  location            = azurerm_resource_group.spokeprodrg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

#  Create LB 

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

# resource Backend address pool

resource "azurerm_lb_backend_address_pool" "spoke-prod-web_lb_backend_address_pool" {
  name            = "spoke-prod-web-backend"
  loadbalancer_id = azurerm_lb.spoke-prod-web-lb.id
}
# create Lb Prob

resource "azurerm_lb_probe" "spoke-prod-web_lb_prob" {
  name                = "tcp-prob"
  protocol            = "Tcp"
  port                = 80
  loadbalancer_id     = azurerm_lb.spoke-prod-web-lb.id
  resource_group_name = azurerm_resource_group.spokeprodrg.name
}

# Create Lb rule

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


# Associate NIC (VM) & LB

resource "azurerm_network_interface_backend_address_pool_association" "spoke-prod-web_nic_lb_associate" {
  count                   = var.spoke-prod-vm-instance-count
  network_interface_id    = element(azurerm_network_interface.spoke-prod-nic[*].id, count.index)
  ip_configuration_name   = azurerm_network_interface.spoke-prod-nic[count.index].ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.spoke-prod-web_lb_backend_address_pool.id
} 