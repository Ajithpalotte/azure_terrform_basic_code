# Storage Account Creation

resource "azurerm_storage_account" "hub-prod-storage-account" {
  name                     = "hubprod${random_string.ramdom_assignment.id}"
  resource_group_name      = azurerm_resource_group.hubrg.name
  location                 = azurerm_resource_group.hubrg.location
  account_replication_type = "GRS"
  account_tier             = "Standard"
}

resource "azurerm_storage_container" "hub-prod-storage-account_container" {
  name                  = "hubprodstorageaccount-container"
  storage_account_name  = azurerm_storage_account.hub-prod-storage-account.name
  container_access_type = "private"
}