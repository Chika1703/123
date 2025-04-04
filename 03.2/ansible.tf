resource "local_file" "ansible_inventory" {
  content  = templatefile("${path.module}/inventory.tpl", {
    webservers = var.webservers
    databases  = var.databases
    storage    = var.storage
  })
  filename = "${path.module}/ansible_inventory"
}
