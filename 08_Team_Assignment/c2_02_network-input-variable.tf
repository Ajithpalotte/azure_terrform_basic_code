# management Vlan name
variable "mgmt_vlan_name" {
  description = "management Vlan name"
  type        = string
  default     = "mgmt-vlan"
}
# management Vlan address space
variable "mgmt_vlan_address_space" {
  description = "management address space"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}
# mgmt-windows subnet name
variable "mgmt_windows_vm_subnet_name" {
  description = "mgmt-windows subnet name"
  type        = string
  default     = "mgmt-winvm-subnet"

}
# mgmt-windows subnet address space
variable "mgmt_windows_vm_address_space" {
  description = "mgmt-windows subnet address space"
  type        = list(string)
  default     = ["10.0.1.0/24"]

}
# mgmt-linux subnet name
variable "mgmt_linux_vm_subnet_name" {
  description = "mgmt-linux subnet name"
  type        = string
  default     = "mgmt-linvm-subnet"

}
# mgmt-linux subnet address space
variable "mgmt_linux_vm_address_space" {
  description = "mgmt-linux subnet address space"
  type        = list(string)
  default     = ["10.0.2.0/24"]

} 
# mgmt-windows public IP 
# mgmt-linux public IP 


# application Vlan name
variable "app_vlan_name" {
  description = "application Vlan name"
  type        = string
  default     = "app-vlan"
}
# application Vlan address space
variable "app_vlan_address_space" {
  description = "application address space"
  type        = list(string)
  default     = ["20.0.0.0/16"]
}
# application-windows subnet name
variable "app_windows_vm_subnet_name" {
  description = "app-windows subnet name"
  type        = string
  default     = "app-winvm-subnet"
}
# app-windows subnet address space
variable "app_windows_vm_address_space" {
  description = "app-windows subnet address space"
  type        = list(string)
  default     = ["20.0.1.0/24"]

}
# application-linux subnet name
variable "app_linux_vm_subnet_name" {
  description = "app-linux subnet name"
  type        = string
  default     = "app-linux-subnet"
}
# app-Linux subnet address space
variable "app_linux_vm_address_space" {
  description = "app-linux subnet address space"
  type        = list(string)
  default     = ["20.0.2.0/24"]

}
