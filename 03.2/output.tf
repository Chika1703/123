output "vm_list" {
  value = [
    for i, server in twc_server.web : {
      name = server.name,
      id   = server.id,
      ipv4 = twc_floating_ip.web_ips[i].ip
    }
  ]
}
output "attached_disks" {
  value = twc_server_disk.additional_disks[*]
}
