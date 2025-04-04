output "web_server" {
  value = {
    name        = twc_server.web_server.name
    external_ip = twc_server.web_server.networks[0].ips[0].ip
    id          = twc_server.web_server.id
  }
}

output "db_server" {
  value = {
    name        = twc_server.db_server.name
    external_ip = twc_server.db_server.networks[0].ips[0].ip
    id          = twc_server.db_server.id
  }
}
