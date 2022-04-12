# resource group creation

resource "azurerm_resource_group" "RG1" {
  name     = "my-RG1"
  location = "var.resource_group_location"
  
}