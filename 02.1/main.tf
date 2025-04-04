data "twc_configurator" "configurator" {
  location    = "ru-1"
  preset_type = "premium"
}

data "twc_os" "os" {
  name    = "ubuntu"
  version = "22.04"
}

resource "twc_ssh_key" "default" {
  name = "netology-key"
  body = var.vm_ssh_public_key # Используем переменную
}

resource "twc_server" "web_server" {
  name    = local.vm_web_full_name # Используем local
  os_id   = data.twc_os.os.id
  ssh_keys_ids = [twc_ssh_key.default.id]

  configuration {
    configurator_id = data.twc_configurator.configurator.id
    disk            = 1024 * 15
    cpu             = var.vms_resources.web.cpu
    ram             = var.vms_resources.web.ram
  }
}

resource "twc_server" "db_server" {
  name    = local.vm_db_full_name # Используем local
  os_id   = data.twc_os.os.id
  ssh_keys_ids = [twc_ssh_key.default.id]

  configuration {
    configurator_id = data.twc_configurator.configurator.id
    disk            = 1024 * 15
    cpu             = var.vms_resources.db.cpu
    ram             = var.vms_resources.db.ram
  }
}