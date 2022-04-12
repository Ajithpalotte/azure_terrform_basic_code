resource "azurerm_resource_group" "RG1" {
    name = "${local.resource_name_prefix}-${var.resource_group_name}"
    location = var.resource_group_location
}