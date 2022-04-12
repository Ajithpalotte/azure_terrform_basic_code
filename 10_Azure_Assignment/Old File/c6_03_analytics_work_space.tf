# Creating Log analytics work space

resource "azurerm_log_analytics_workspace" "hub-prod-workspace" {
  name                = "hub-prod-log-analytics-workspace"
  location            = azurerm_resource_group.hubrg.location
  resource_group_name = azurerm_resource_group.hubrg.name
  retention_in_days   = 45
}

# Create VM extention for windows VM

data "azurerm_log_analytics_workspace" "workspace_azuredata" {
  name                = azurerm_log_analytics_workspace.hub-prod-workspace.name
  resource_group_name = azurerm_resource_group.hubrg.name

}

resource "azurerm_virtual_machine_extension" "spoke-prod-winvn-ext" {
  count                      = var.spoke-prod-vm-instance-count
  name                       = "spoke-prod-winvm-monitoring-ext-${count.index}"
  virtual_machine_id         = element(azurerm_windows_virtual_machine.spokeprod-app1-vm[*].id, count.index)
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "MicrosoftMonitoringAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  settings           = <<SETTINGS
       {
         "workspaceId": "${data.azurerm_log_analytics_workspace.workspace_azuredata.workspace_id}"
          }
       SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
      {
         "workspaceKey": "${data.azurerm_log_analytics_workspace.workspace_azuredata.primary_shared_key}"
      } 
    PROTECTED_SETTINGS  
}


resource "azurerm_virtual_machine_extension" "spoke-prod-DependencyAgentWindows" {
  count                      = var.spoke-prod-vm-instance-count
  name                       = "spoke-prod-DependencyAgentWindows-${count.index}"
  virtual_machine_id         = element(azurerm_windows_virtual_machine.spokeprod-app1-vm[*].id, count.index)
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentWindows"
  type_handler_version       = "9.1"
  auto_upgrade_minor_version = true
}
/*---------------------------------------------------------------------------------*/

resource "azurerm_virtual_machine_extension" "spoke-dev-winvn-ext" {
  count                      = var.spoke-dev-vm-instance-count
  name                       = "spoke-dev-winvm-monitoring-ext-${count.index}"
  virtual_machine_id         = element(azurerm_windows_virtual_machine.spokedev-app1-vm[*].id, count.index)
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "MicrosoftMonitoringAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  settings           = <<SETTINGS
       {
         "workspaceId": "${data.azurerm_log_analytics_workspace.workspace_azuredata.workspace_id}"
          }
       SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
      {
         "workspaceKey": "${data.azurerm_log_analytics_workspace.workspace_azuredata.primary_shared_key}"
      } 
    PROTECTED_SETTINGS  
}


resource "azurerm_virtual_machine_extension" "spoke-dev-DependencyAgentWindows" {
  count                      = var.spoke-dev-vm-instance-count
  name                       = "spoke-dev-DependencyAgentWindows-${count.index}"
  virtual_machine_id         = element(azurerm_windows_virtual_machine.spokedev-app1-vm[*].id, count.index)
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentWindows"
  type_handler_version       = "9.1"
  auto_upgrade_minor_version = true
}


