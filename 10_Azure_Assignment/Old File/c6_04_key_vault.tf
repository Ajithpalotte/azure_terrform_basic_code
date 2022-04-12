data "azurerm_client_config" "current" {}

# Resource-1: Azure Key Vault
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







resource "azurerm_key_vault_certificate" "Spoke-prod-Cert" {
  name         = "spoke-prod-cert"
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


/*
resource "azurerm_key_vault_certificate" "import-Spoke-prod-cert" {
  name         ="import-Spoke-prod-cert"
  key_vault_id = azurerm_key_vault.hub-prod-keyvault1.id
  certificate {
    contents = filebase64("cert.pfx")
  } */












/*

resource "azurerm_virtual_machine_extension" "spoke-dev-keyvault-ext" {
  count                      = var.spoke-dev-vm-instance-count
  name                       = "spoke-dev-keyvault-ext-${count.index}"
  virtual_machine_id         = element(azurerm_windows_virtual_machine.spokedev-app1-vm[*].id, count.index)
  publisher                  = "Microsoft.Azure.KeyVault.Edp"
  type                       = "KeyVaultForWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}  */
