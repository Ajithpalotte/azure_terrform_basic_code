# spoke dev Subnet

resource "azurerm_subnet" "spokedev-subnet" {
  name                 = "spoke-dev-subnet"
  resource_group_name  = azurerm_resource_group.spokedevrg.name
  virtual_network_name = azurerm_virtual_network.spoke-dev-vlan.name
  address_prefixes     = var.spokedev_subnet_address_space

}

# spoke prod Subnet

resource "azurerm_subnet" "spokeprod-subnet" {
  name                 = "spoke-prod-subnet"
  resource_group_name  = azurerm_resource_group.spokeprodrg.name
  virtual_network_name = azurerm_virtual_network.spoke-prod-vlan.name
  address_prefixes     = var.spokeprod_subnet_address_space

}

resource "azurerm_public_ip" "spoke-prod-public-ip" {
  name                = "spoke-prod-public-ip"
  resource_group_name = azurerm_resource_group.spokeprodrg.name
  location            = azurerm_resource_group.spokeprodrg.location
  allocation_method   = "Dynamic"

}

resource "azurerm_public_ip" "spoke-dev-public-ip" {
  name                = "spoke-dev-public-ip"
  resource_group_name = azurerm_resource_group.spokedevrg.name
  location            = azurerm_resource_group.spokedevrg.location
  allocation_method   = "Dynamic"

}


