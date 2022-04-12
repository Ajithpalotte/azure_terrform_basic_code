#project name
variable "project" {
  description = "project  name and details"
  type = string
  default = "aim"
}

#Environment Details
variable "environment" {
    description = "Update the project Environment"
    type = string
    default = "dev"
}

# Windows OS info
variable "winos" {
    description = "Windows Operating System"
    type = string
    default = "w"
}

# Linux OS info
variable "linuxos" {
    description = "Linux Operating System"
    type = string
    default = "l"
}

#resource group Name
variable "resource_group_name" {
  description = "Resource Group Name"
  type = string
  default = "ajith_rg"
}

#resource group Location
variable "resource_group_location" {
  description = "Resource Group Location"
  type = string
  default = "eastus"
}
