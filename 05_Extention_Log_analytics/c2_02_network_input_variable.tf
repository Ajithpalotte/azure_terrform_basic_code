# MGMT Virtual Network Name

variable "vnet_mgmt" {
  description = "Management virtual network name"
  type        = string
  default     = "vnet_mgmt"
}

# MGMT Virtual Network address space

variable "mgmtvnet_address_space" {
  description = "MGMT Virtual network address"
  type        = list(string)
  default     = ["20.0.0.0/16"]
}

# app Virtual Network Name
variable "vnet_app" {
  description = "app virtual network name"
  type        = string
  default     = "vnet_app"
}

# App Virtual Network address space
variable "appvnet_address_space" {
  description = "app Virtual network address"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

# mgmt subnet name

variable "mgmt_subnet_name" {
  description = "mgmt servers subnet details"
  type        = string
  default     = "mgmtsubnet"
}

# mgmt subnet address space

variable "mgmt_subnet_address" {
  description = "mgmt servers subnet details"
  type        = list(string)
  default     = ["20.0.1.0/24"]
}

# app subnet name

variable "app_subnet_name" {
  description = "appservers subnet details"
  type        = string
  default     = "appsubnet"
}

# app  subnet address space

variable "app_subnet_address" {
  description = "appx servers subnet details"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

# mgmt linux server  public IP name

variable "mgmt_linux_public_ip_name" {
  description = "mgmt Linux servers subnet details"
  type        = string
  default     = "mgmt_linuxvm_publicip"
}

# app public IP name

variable "app__public_ip_name" {
  description = "app servers subnet details"
  type        = string
  default     = "appvm_publicip"
}





