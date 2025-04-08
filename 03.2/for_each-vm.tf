resource "twc_floating_ip" "db_ips" {
  for_each          = { for db in var.databases : db.name => db if db.floating_ip }
  availability_zone = var.availability_zone
}

resource "twc_server" "databases" {
  for_each          = { for db in var.databases : db.name => db }
  name              = each.value.name
  preset_id         = each.value.preset_id
  project_id        = var.project_id
  os_id             = var.os_id
  availability_zone = var.availability_zone
  ssh_keys_ids      = each.value.ssh_keys_ids
  floating_ip_id    = twc_floating_ip.db_ips[each.key].id
  depends_on = [twc_server.web] 
}
