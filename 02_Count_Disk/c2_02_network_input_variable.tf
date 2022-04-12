# Virtual Network Name

variable "vnet_name" {
  description = "virtual network name"
  type        = string
  default     = "vnet_default"
}

# Virtual Network address space

variable "vnet_address_space" {
  description = "Virtual network address"
  type        = list(string)
  default     = ["20.0.0.0/16"]
}

# Windows subnet name

variable "windows_subnet_name" {
  description = "Windows servers subnet details"
  type        = string
  default     = "winsubnet"
}

# Windows subnet address space

variable "windows_subnet_address" {
  description = "Windows servers subnet details"
  type        = list(string)
  default     = ["20.0.1.0/24"]
}

# Linux subnet name

variable "linux_subnet_name" {
  description = "Linux servers subnet details"
  type        = string
  default     = "linuxsubnet"
}

# Linux  subnet address space

variable "linux_subnet_address" {
  description = "Linux servers subnet details"
  type        = list(string)
  default     = ["20.0.2.0/24"]
}

# Linux public IP name

variable "linux_public_ip_name" {
  description = "Linux servers subnet details"
  type        = string
  default     = "linuxvm_publicip"
}

# windows public IP name

variable "windows_public_ip_name" {
  description = "windows servers subnet details"
  type        = string
  default     = "windowsvm_publicip"
}





