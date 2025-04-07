resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    webservers_ips = twc_floating_ip.web_ips[*].ip
    storage_ip     = twc_floating_ip.storage_ip[0].ip
  })
  filename = "${path.module}/ansible_inventory"
}
