resource "twc_server" "databases" {
  count = 2
  name  = "database-${count.index + 1}"

  preset_id         = var.web_preset_id
  project_id        = var.project_id
  os_id             = var.os_id
  availability_zone = var.availability_zone
  ssh_keys_ids      = var.ssh_keys_ids
}

resource "twc_floating_ip" "db_ips" {
  count             = 2
  availability_zone = var.availability_zone
}