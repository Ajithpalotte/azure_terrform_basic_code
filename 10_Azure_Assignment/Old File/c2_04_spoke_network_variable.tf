# spoke dev vlan name
variable "spoke_dev_vlan_name" {
  description = "spoke dev Vlan name"
  type        = string
  default     = "spoke-vlan"
}

# spoke dev  address space
variable "spoke_dev_address_space" {
  description = "spoke dev address space"
  type        = list(string)
  default     = ["10.105.0.0/16"]
}


# spoke dev subnet name
variable "spokedev_subnet_name" {
  description = "spoke dev subnet name"
  type        = string
  default     = "spoke-subnet"

}

# spok dev subnet address space
variable "spokedev_subnet_address_space" {
  description = "spoke dev subnet subnet address space"
  type        = list(string)
  default     = ["10.105.1.0/24"]
}



# spoke prod vlan name
variable "spoke_prod_vlan_name" {
  description = "spoke dev Vlan name"
  type        = string
  default     = "spoke-vlan"
}

# spoke prod  address space
variable "spoke_prod_address_space" {
  description = "spoke prod address space"
  type        = list(string)
  default     = ["10.110.0.0/16"]
}


# spoke prod subnet name
variable "spokeprod_subnet_name" {
  description = "spoke prod subnet name"
  type        = string
  default     = "spoke-subnet"
}

# spok prod subnet address space
variable "spokeprod_subnet_address_space" {
  description = "spoke dev subnet subnet address space"
  type        = list(string)
  default     = ["10.110.1.0/24"]
}

# spoke dev app1 public IP name

variable "spoke-dev-app1-public-ip-name" {
  description = "spoke dev app 1 public IP"
  type        = string
  default     = "spoke-app1-public-ip"
}





