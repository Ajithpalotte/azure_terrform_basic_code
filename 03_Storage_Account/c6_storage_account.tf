# Storage Account Creation

resource "azurerm_storage_account" "app1" {
  name                     = "ajithteststraccount"
  resource_group_name      = azurerm_resource_group.myrg1.name
  location                 = azurerm_resource_group.myrg1.location
  account_replication_type = "GRS"
  account_tier             = "Standard"
}

resource "azurerm_storage_container" "app1_container" {
  name                  = "app1container"
  storage_account_name  = azurerm_storage_account.app1.name
  container_access_type = "private"
}