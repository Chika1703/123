output "servers_info" {
  description = "Информация о созданных серверах"
  value = {
    for key, server in twc_server.server : key => {
      name        = server.name
      external_ip = server.networks[0].ips[0].ip
      id          = server.id
    }
  }
}
