# Terraform Setting Block
terraform {
  required_providers {
      azurerm = {
      source = "hashicorp/azurerm"
      version = ">=2.9"
    }
  }
}

# provider Block
provider "azurerm" {
  features{}
}


# Resource Group

resource "azurerm_resource_group" "testrg" {
  name = "rg1"
  location = "eastus"
}

resource "azurerm_virtual_network" "testvlan" {
  name = "testvlan1"
  location = azurerm_resource_group.testrg.location
  resource_group_name = azurerm_resource_group.testrg.name
  address_space = [ "10.1.0.0/16" ]
  tags = {
    "project" = "AIM"
    "env." = "Dev"
  }
}

resource "azurerm_subnet" "testsubnet" {
  name = "testsub-1"
  #location=azurerm_resource_group.ajithrg.location
  resource_group_name = azurerm_resource_group.testrg.name
  virtual_network_name = azurerm_virtual_network.testvlan.name
  address_prefixes = [ "10.1.0.0/24" ]
  
} 


