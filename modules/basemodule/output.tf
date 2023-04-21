output "vm_ip" {
  value = vsphere_virtual_machine.vm.*.allocated_ipv4_addr
}