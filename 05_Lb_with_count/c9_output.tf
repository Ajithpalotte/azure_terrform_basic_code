output "rgdetails" {
  value = azurerm_resource_group.myrg1
}

output "linux_nic" {
  value = azurerm_network_interface.linuxvm_nic_interface[*].id

}

output "linux_VM_Details" {
  value = azurerm_linux_virtual_machine.linuxvm[*].name
}