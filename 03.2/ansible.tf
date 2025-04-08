resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    webservers_ips = twc_floating_ip.web_ips[*].ip,
    webservers_dns = ["web-1.tw1.ru", "web-2.tw1.ru"],
    database_ips   = [for db in twc_floating_ip.db_ips : db.ip],
    database_dns   = ["databases-1.tw1.ru", "databases-2.tw1.ru"],
    storage_ip     = twc_floating_ip.storage_ip[0].ip,
    storage_dns    = "storage-1.tw1.ru"
  })
  filename = "${path.module}/ansible_inventory"
}
