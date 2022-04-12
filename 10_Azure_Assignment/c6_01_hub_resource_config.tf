#------------------------------------------------#
# Storage Account Creation for HUB
#------------------------------------------------#

resource "azurerm_storage_account" "hub-prod-storage-account" {
  name                     = "hubprod${random_string.ramdom_assignment.id}"
  resource_group_name      = azurerm_resource_group.hubrg.name
  location                 = azurerm_resource_group.hubrg.location
  account_replication_type = "GRS"
  account_tier             = "Standard"
}

#------------------------------------------------#
# Container account creation for HUB
#------------------------------------------------#

resource "azurerm_storage_container" "hub-prod-storage-account_container" {
  name                  = "hubprodstorageaccount-container"
  storage_account_name  = azurerm_storage_account.hub-prod-storage-account.name
  container_access_type = "private"
}

#------------------------------------------------#
# Network peering from Hub to spoke Dev
#------------------------------------------------#

resource "azurerm_virtual_network_peering" "hub-spokedev-peering" {
  name                      = "hub-spoke-dev-peering"
  resource_group_name       = azurerm_resource_group.hubrg.name
  virtual_network_name      = azurerm_virtual_network.hub-vlan.name
  remote_virtual_network_id = azurerm_virtual_network.spoke-dev-vlan.id
}

#------------------------------------------------#
# Network peering from spoke Dev to Hub
#------------------------------------------------#

resource "azurerm_virtual_network_peering" "spokedev-hub-peering" {
  name                      = "spoke-dev-hub-peering"
  resource_group_name       = azurerm_resource_group.spokedevrg.name
  virtual_network_name      = azurerm_virtual_network.spoke-dev-vlan.name
  remote_virtual_network_id = azurerm_virtual_network.hub-vlan.id
}

#------------------------------------------------#
# Network peering from Hub to spoke prod
#------------------------------------------------#

resource "azurerm_virtual_network_peering" "hub-spokeprod-peering" {
  name                      = "hub-spoke-prod-peering"
  resource_group_name       = azurerm_resource_group.hubrg.name
  virtual_network_name      = azurerm_virtual_network.hub-vlan.name
  remote_virtual_network_id = azurerm_virtual_network.spoke-prod-vlan.id
}

#------------------------------------------------#
# Network peering from spoke prod to Hub
#------------------------------------------------#

resource "azurerm_virtual_network_peering" "spokeprod-hub-peering" {
  name                      = "spoke-prod-hub-peering"
  resource_group_name       = azurerm_resource_group.spokeprodrg.name
  virtual_network_name      = azurerm_virtual_network.spoke-prod-vlan.name
  remote_virtual_network_id = azurerm_virtual_network.hub-vlan.id
}

#------------------------------------------------#
# Creating Log analytics work space for HUB
#------------------------------------------------#

resource "azurerm_log_analytics_workspace" "hub-prod-workspace" {
  name                = "hub-prod-log-analytics-workspace"
  location            = azurerm_resource_group.hubrg.location
  resource_group_name = azurerm_resource_group.hubrg.name
  retention_in_days   = 45
}

data "azurerm_log_analytics_workspace" "workspace_azuredata" {
  name                = azurerm_log_analytics_workspace.hub-prod-workspace.name
  resource_group_name = azurerm_resource_group.hubrg.name

}

#------------------------------------------------#
# Creating Log extensions for  for spoke prod vms
#------------------------------------------------#

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

#-------------------------------------------------#
# Creating Log extensions for  for spoke dev vms
#-------------------------------------------------#

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

#-------------------------------------------------#
# Creating Azure Key Vault for hub
#-------------------------------------------------#

data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "hub-prod-keyvault1" {
  name                            = "hub-prod-keyvault1"
  location                        = azurerm_resource_group.hubrg.location
  resource_group_name             = azurerm_resource_group.hubrg.name
  enabled_for_disk_encryption     = true
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = 7
  purge_protection_enabled        = false
  enabled_for_template_deployment = true
  sku_name                        = "standard"
}

#-------------------------------------------------#
# Creating the key vault access policy
#-------------------------------------------------#

resource "azurerm_key_vault_access_policy" "hub-prod-key_vault_default_policy" {
  key_vault_id = azurerm_key_vault.hub-prod-keyvault1.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id
  lifecycle {
    create_before_destroy = true
  }
  certificate_permissions = [
    "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "Update"
  ]
  key_permissions = [
    "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List",
  ]
  secret_permissions = [
    "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
  ]
}

#-------------------------------------------------#
# Creating the self signed certificate
#-------------------------------------------------#

resource "azurerm_key_vault_certificate" "Spoke-prod-Cert" {
  name         = "spoke-prod-cert1"
  key_vault_id = azurerm_key_vault.hub-prod-keyvault1.id
  certificate_policy {
    issuer_parameters {
      name = "self"

    }
    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }
      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      # Server Authentication = 1.3.6.1.5.5.7.3.1
      # Client Authentication = 1.3.6.1.5.5.7.3.2
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]

      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject_alternative_names {
        dns_names = ["internal.contoso.com", "domain.hello.world"]
      }

      subject            = "CN=hello-world, OU=azure"
      validity_in_months = 12

    }
  }
}

#-------------------------------------------------#
# Create network interface for hub jump VM
#-------------------------------------------------#

resource "azurerm_network_interface" "hub-jump-vm-nic-interface" {

  name                = "hub-jump-vm-nic-interface-app1-nic"
  location            = azurerm_resource_group.hubrg.location
  resource_group_name = azurerm_resource_group.hubrg.name
  ip_configuration {
    name                          = "hub-jump-vm-ip-1"
    subnet_id                     = azurerm_subnet.hub-subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.hub-public-ip.id

  }
}


#-------------------------------------------------#
# Create HUB Jump VM 
#-------------------------------------------------#
resource "azurerm_windows_virtual_machine" "hub-jump-vm" {
  name                  = "hub-jump-vm" #max 15 characters
  resource_group_name   = azurerm_resource_group.hubrg.name
  location              = azurerm_resource_group.hubrg.location
  size                  = "Standard_F2"
  admin_username        = "adminaim"
  admin_password        = "Password@123"
  network_interface_ids = [azurerm_network_interface.hub-jump-vm-nic-interface.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}





