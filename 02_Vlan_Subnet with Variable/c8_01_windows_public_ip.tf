# Resource-1 : Creating public ip for linux Vm

resource "azurerm_public_ip" "windowsvm_public_ip_address" {
    name = "${local.resource_name_prefix}-${var.windows_public_ip_name}"
    resource_group_name = azurerm_resource_group.myrg1.name
    location = azurerm_resource_group.myrg1.location
    allocation_method = "Static"
}