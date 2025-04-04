output "vm_list" {
  value = [
    for vm in twc_server.web :
    {
      name = vm.name,
      id   = vm.id,
      fqdn = vm.main_ipv4
    }
  ]
}
output "attached_disks" {
  value = twc_server_disk.additional_disks[*]
}
