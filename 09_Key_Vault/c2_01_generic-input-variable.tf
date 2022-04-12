# Project Details
variable "project_name" {
  description = "Project Name and details"
  type        = string
  default     = "azure"
}

#Environment Details

variable "environment" {
  description = "Project environment and details"
  type        = string
  default     = "dev"
}

# Resource group name and location
variable "resource_group_name" {
  description = "resource group name and details"
  type        = string
  default     = "ajithrg"
}

variable "resource_group_location" {
  description = "resource group location and details"
  type        = string
  default     = "eastus"
}

# windows server naming details

variable "windows_server_name" {
  description = "naming convertions for windows servers"
  type        = string
  default     = "win"
}

# Linux server naming details

variable "Linux_server_name" {
  description = "naming convertions for Linux servers"
  type        = string
  default     = "lin"
}


