#-------------------------------------------#
# zone Details
#-------------------------------------------#
variable "zone_hub" {
  description = "Project Name and details"
  type        = string
  default     = "hub"
}

variable "zone_spoke" {
  description = "Project Name and details"
  type        = string
  default     = "spoke"
}

variable "team_name" {
  description = "team Name and details"
  type        = string
  default     = "aim"
}

#-------------------------------------------#
#Environment Details
#-------------------------------------------#

variable "environment_prod" {
  description = "Project environment and details"
  type        = string
  default     = "prod"
}

variable "environment_dev" {
  description = "Project environment and details"
  type        = string
  default     = "dev"
}


#-------------------------------------------#
# Resource group name and location
#-------------------------------------------#
variable "resource_group_name" {
  description = "resource group name and details"
  type        = string
  default     = "default"
}

variable "resource_group_location" {
  description = "resource group location and details"
  type        = string
  default     = "eastus"
}

#-------------------------------------------#
# VM instance count for spoke dev
#-------------------------------------------#
variable "spoke-dev-vm-instance-count" {
  description = "spoke VM instance count"
  type        = number
  default     = 2
}

#-------------------------------------------#
# VM instance count for spoke prod
#-------------------------------------------#
variable "spoke-prod-vm-instance-count" {
  description = "spoke prod VM instance count"
  type        = number
  default     = 2
}


#-------------------------------------------#
#HUB Network variable configuration
#-------------------------------------------#
# hub Vlan name
#-------------------------------------------#
variable "hub_vlan_name" {
  description = "hub Vlan name"
  type        = string
  default     = "hub-vlan"
}

#-------------------------------------------#
# hub Vlan address space
#-------------------------------------------#

variable "hub_vlan_address_space" {
  description = "hub vlan address space"
  type        = list(string)
  default     = ["10.100.0.0/16"]
}

#-------------------------------------------#
# hub subnet name
#-------------------------------------------#

variable "hub_subnet_name" {
  description = "hub subnet name"
  type        = string
  default     = "hub-subnet"

}
#-------------------------------------------#
# hub subnet address space
#-------------------------------------------#
variable "hub_subnet_address_space" {
  description = "hub subnet subnet address space"
  type        = list(string)
  default     = ["10.100.1.0/24"]
}

#-------------------------------------------#
# Spoke  Network variable configuration
#-------------------------------------------#
# spoke dev vlan name
#-------------------------------------------#

variable "spoke_dev_vlan_name" {
  description = "spoke dev Vlan name"
  type        = string
  default     = "spoke-vlan"
}

#-------------------------------------------#
# spoke dev  address space
#-------------------------------------------#

variable "spoke_dev_address_space" {
  description = "spoke dev address space"
  type        = list(string)
  default     = ["10.105.0.0/16"]
}

#-------------------------------------------#
# spoke dev subnet name
#-------------------------------------------#

variable "spokedev_subnet_name" {
  description = "spoke dev subnet name"
  type        = string
  default     = "spoke-subnet"

}

#-------------------------------------------#
# spoke dev subnet address space
#-------------------------------------------#
variable "spokedev_subnet_address_space" {
  description = "spoke dev subnet subnet address space"
  type        = list(string)
  default     = ["10.105.1.0/24"]
}

#-------------------------------------------#
# spoke prod vlan name
#-------------------------------------------#
variable "spoke_prod_vlan_name" {
  description = "spoke dev Vlan name"
  type        = string
  default     = "spoke-vlan"
}

#-------------------------------------------#
# spoke prod  address space
#-------------------------------------------#
variable "spoke_prod_address_space" {
  description = "spoke prod address space"
  type        = list(string)
  default     = ["10.110.0.0/16"]
}

#-------------------------------------------#
# spoke prod subnet name
#-------------------------------------------#
variable "spokeprod_subnet_name" {
  description = "spoke prod subnet name"
  type        = string
  default     = "spoke-subnet"
}

#-------------------------------------------#
# spoke prod subnet address space
#-------------------------------------------#
variable "spokeprod_subnet_address_space" {
  description = "spoke dev subnet subnet address space"
  type        = list(string)
  default     = ["10.110.1.0/24"]
}

#-------------------------------------------#
# spoke dev app1 public IP name
#-------------------------------------------#
variable "spoke-dev-app1-public-ip-name" {
  description = "spoke dev app 1 public IP"
  type        = string
  default     = "spoke-app1-public-ip"
}










