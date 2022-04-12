# resource group creation

resource "azurerm_resource_group" "myrg1" {
    name = "${local.resource_name_prefix}-${var.resource_group_name}"
    location = var.resource_group_location
    tags = local.project_tags
}