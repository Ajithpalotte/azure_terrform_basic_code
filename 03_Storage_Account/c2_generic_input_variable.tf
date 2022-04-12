#project name
variable "project" {
  description = "project  name and details"
  type        = string
  default     = "aim"
}

#Environment Details
variable "environment" {
  description = "Update the project Environment"
  type        = string
  default     = "dev"
}
#resource group Name
variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
  default     = "ajith_rg"
}

#resource group Location
variable "resource_group_location" {
  description = "Resource Group Location"
  type        = string
  default     = "eastus"
}
