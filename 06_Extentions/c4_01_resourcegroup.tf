# resource group creation

resource "azurerm_resource_group" "RG1" {
  name     = "${local.resource_name_prefix}-RG1"
  location = var.resource_group_location
  tags     = local.project_tags
}