output "web_server" {
  value = {
    name        = twc_server.web_server.name
    external_ip = twc_server.web_server.main_ipv4
    id          = twc_server.web_server.id
  }
}

output "db_server" {
  value = {
    name        = twc_server.db_server.name
    external_ip = twc_server.db_server.main_ipv4
    id          = twc_server.db_server.id
  }
}