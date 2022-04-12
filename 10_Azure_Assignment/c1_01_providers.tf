terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.9"
    }
  }
}


provider "azurerm" {
  features {}
}

provider "random" {
}


#-------------------------------------------#
# Random Configuration
#-------------------------------------------#

resource "random_string" "ramdom_assignment" {
  length  = 4
  lower   = true
  upper   = false
  number  = false
  special = false
}