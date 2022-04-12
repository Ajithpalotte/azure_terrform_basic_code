#-------------------------------------------#
# create hub virtual network
#-------------------------------------------#

resource "azurerm_virtual_network" "hub-vlan" {

  name                = "${local.hub_resource_name_prefix}-${var.hub_vlan_name}"
  location            = azurerm_resource_group.hubrg.location
  resource_group_name = azurerm_resource_group.hubrg.name
  address_space       = var.hub_vlan_address_space
  tags                = local.hub_tags
}

#-------------------------------------------#
# create spoke dev virtual network
#-------------------------------------------#

resource "azurerm_virtual_network" "spoke-dev-vlan" {

  name                = "${local.spoke_dev_resource_name_prefix}-${var.spoke_dev_vlan_name}"
  location            = azurerm_resource_group.spokedevrg.location
  resource_group_name = azurerm_resource_group.spokedevrg.name
  address_space       = var.spoke_dev_address_space
  tags                = local.spoke_dev_tags
}

#-------------------------------------------#
# create spoke prod virtual network
#-------------------------------------------#

resource "azurerm_virtual_network" "spoke-prod-vlan" {

  name                = "${local.spoke_prod_resource_name_prefix}-${var.spoke_prod_vlan_name}"
  location            = azurerm_resource_group.spokeprodrg.location
  resource_group_name = azurerm_resource_group.spokeprodrg.name
  address_space       = var.spoke_prod_address_space
  tags                = local.spoke_prod_tags
}

#-------------------------------------------#
# HUB Subnet creation
#-------------------------------------------#
resource "azurerm_subnet" "hub-subnet" {
  name                 = "${local.hub_resource_name_prefix}-${var.hub_subnet_name}"
  resource_group_name  = azurerm_resource_group.hubrg.name
  virtual_network_name = azurerm_virtual_network.hub-vlan.name
  address_prefixes     = var.hub_subnet_address_space

}

#-------------------------------------------#
# HUB Public IP creation
#-------------------------------------------#

resource "azurerm_public_ip" "hub-public-ip" {
  name                = "hub-public-ip"
  resource_group_name = azurerm_resource_group.hubrg.name
  location            = azurerm_resource_group.hubrg.location
  allocation_method   = "Dynamic"

}

#-------------------------------------------#
# spoke dev Subnet creation
#-------------------------------------------#

resource "azurerm_subnet" "spokedev-subnet" {
  name                 = "spoke-dev-subnet"
  resource_group_name  = azurerm_resource_group.spokedevrg.name
  virtual_network_name = azurerm_virtual_network.spoke-dev-vlan.name
  address_prefixes     = var.spokedev_subnet_address_space

}

#-------------------------------------------#
# spoke prod Subnet creation
#-------------------------------------------#
resource "azurerm_subnet" "spokeprod-subnet" {
  name                 = "spoke-prod-subnet"
  resource_group_name  = azurerm_resource_group.spokeprodrg.name
  virtual_network_name = azurerm_virtual_network.spoke-prod-vlan.name
  address_prefixes     = var.spokeprod_subnet_address_space

}

#-------------------------------------------#
# spoke prod public IP creation
#-------------------------------------------#

resource "azurerm_public_ip" "spoke-prod-public-ip" {
  name                = "spoke-prod-public-ip"
  resource_group_name = azurerm_resource_group.spokeprodrg.name
  location            = azurerm_resource_group.spokeprodrg.location
  allocation_method   = "Dynamic"

}

#-------------------------------------------#
# spoke dev public IP creation
#-------------------------------------------#

resource "azurerm_public_ip" "spoke-dev-public-ip" {
  name                = "spoke-dev-public-ip"
  resource_group_name = azurerm_resource_group.spokedevrg.name
  location            = azurerm_resource_group.spokedevrg.location
  allocation_method   = "Dynamic"

}




