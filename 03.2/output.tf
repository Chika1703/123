output "vm_list" {
  value = [
    for i, server in twc_server.web : {
      name = server.name,
      id   = server.id,
      ipv4 = twc_floating_ip.web_ips[i].ip,
      dns  = ["web-1.tw1.ru", "web-2.tw1.ru"][i]
    }
  ]
}

output "attached_disks" {
  value = [
    for disk in twc_server_disk.additional_disks : {
      id     = disk.id,
      size   = disk.size,
      server = disk.source_server_id # 
    }
  ]
}
