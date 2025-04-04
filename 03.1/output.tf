output "vm_list" {
  value = [
    for vm in twc_server.server :
    {
      name = vm.name,
      id   = vm.id,
      fqdn = vm.main_ipv4
    }
  ]
}
