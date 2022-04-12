# hub Vlan name
variable "hub_vlan_name" {
  description = "hub Vlan name"
  type        = string
  default     = "hub-vlan"
}

# hub Vlan address space
variable "hub_vlan_address_space" {
  description = "hub vlan address space"
  type        = list(string)
  default     = ["10.100.0.0/16"]
}


# hub subnet name
variable "hub_subnet_name" {
  description = "hub subnet name"
  type        = string
  default     = "hub-subnet"

}
# hub subnet address space
variable "hub_subnet_address_space" {
  description = "hub subnet subnet address space"
  type        = list(string)
  default     = ["10.100.1.0/24"]
}
