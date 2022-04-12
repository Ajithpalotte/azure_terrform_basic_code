#-------------------------------------------#
#Hub Resource group
#-------------------------------------------#
resource "azurerm_resource_group" "hubrg" {
  name     = local.hub_resource_group_name
  location = var.resource_group_location
  tags     = local.hub_tags
}

#-------------------------------------------#
# spoke Dev resource group name
#-------------------------------------------#

resource "azurerm_resource_group" "spokedevrg" {
  name     = local.spoke_dev_resource_group_name
  location = var.resource_group_location
  tags     = local.spoke_dev_tags
}

#-------------------------------------------#
# spoke prod resource group name
#-------------------------------------------#
resource "azurerm_resource_group" "spokeprodrg" {
  name     = local.spoke_prod_resource_group_name
  location = var.resource_group_location
  tags     = local.spoke_prod_tags
}

#-------------------------------------------#
# Local variable configuration
#-------------------------------------------#
locals {
  hub              = var.zone_hub
  spoke            = var.zone_spoke
  prod_environment = var.environment_prod
  dev_environment  = var.environment_dev
  team             = var.team_name

  hub_resource_group_name         = "${local.team}-${local.prod_environment}-${local.hub}-rg"
  spoke_prod_resource_group_name  = "${local.team}-${local.prod_environment}-${local.spoke}-rg"
  spoke_dev_resource_group_name   = "${local.team}-${local.dev_environment}-${local.spoke}-rg"
  hub_resource_name_prefix        = "${local.team}-${local.prod_environment}"
  spoke_dev_resource_name_prefix  = "${local.team}-${local.dev_environment}"
  spoke_prod_resource_name_prefix = "${local.team}-${local.prod_environment}"

  hub_tags = {
    environment = local.prod_environment
    zone        = local.hub
  }

  spoke_dev_tags = {
    environment = local.prod_environment
    zone        = local.spoke
  }

  spoke_prod_tags = {
    environment = local.prod_environment
    zone        = local.spoke
  }

}