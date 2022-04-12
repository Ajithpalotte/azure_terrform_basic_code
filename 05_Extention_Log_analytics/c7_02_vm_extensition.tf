# Create VM extention for windows VM

data "azurerm_log_analytics_workspace" "workspace_azuredata" {
  name = "aim-log-analytics-workspace"
  resource_group_name = "aim-blueprint"
  
}


resource "azurerm_virtual_machine_extension" "winvn-ext" {
  name                 = "winvm_monitoring_ext"
  virtual_machine_id   = azurerm_windows_virtual_machine.windowsvm.id
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "MicrosoftMonitoringAgent"
  type_handler_version = "1.0"

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


# Create VM extension for windows VM

resource "azurerm_virtual_machine_extension" "linuxvn-ext" {
  name                 = "linxvm_monitoring_ext"
  virtual_machine_id   = azurerm_linux_virtual_machine.mgmtvm.id
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "OmsAgentForLinux"
  type_handler_version = "1.9"
  auto_upgrade_minor_version = true

  settings           = <<SETTINGS
       {
         "workspaceId" : "${data.azurerm_log_analytics_workspace.workspace_azuredata.workspace_id}"
          }
       SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
      {
         "workspaceKey" : "${data.azurerm_log_analytics_workspace.workspace_azuredata.primary_shared_key}"
     } 
   PROTECTED_SETTINGS  
}


resource "azurerm_virtual_machine_extension" "DependencyAgentWindows" {
  name = "winvm-DependencyAgentWindows"
  virtual_machine_id   = azurerm_windows_virtual_machine.windowsvm.id
    publisher            = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                 = "DependencyAgentWindows"
  type_handler_version = "9.1"

  
}