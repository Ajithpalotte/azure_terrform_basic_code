# Creating Log analytics work space

resource "azurerm_log_analytics_workspace" "test-workspace" {
  name                = "test-log-analytics-workspace"
  location            = azurerm_resource_group.RG1.location
  resource_group_name = azurerm_resource_group.RG1.name
  retention_in_days   = 45
}



