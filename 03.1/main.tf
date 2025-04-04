locals {
  # Преобразуем список серверов в карту для удобной итерации
  servers_map = { for idx, server in var.servers : idx => server }
}

# Создаём плавающие IP-адреса только для серверов, у которых floating_ip = true
resource "twc_floating_ip" "server_ip" {
  for_each = { for idx, server in local.servers_map : idx => server if server.floating_ip }

  availability_zone = var.availability_zone
  ddos_guard        = false
}

# Создаём серверы с использованием управляющих конструкций
resource "twc_server" "server" {
  for_each = local.servers_map

  name                      = each.value.name
  preset_id                 = each.value.preset_id
  project_id                = each.value.project_id
  os_id                     = each.value.os_id
  availability_zone         = var.availability_zone
  is_root_password_required = true
  ssh_keys_ids              = each.value.ssh_keys_ids
  floating_ip_id            = try(twc_floating_ip.server_ip[each.key].id, null)

  # Подключаем сервер к сети и фаерволу
  networks {
    id          = var.local_network_id
    firewall_id = twc_firewall.example.id
  }
}

# Настройка автоматического резервного копирования диска для каждого сервера
resource "twc_server_disk_backup_schedule" "backup" {
  for_each = local.servers_map

  source_server_id      = twc_server.server[each.key].id
  source_server_disk_id = twc_server.server[each.key].disks[0].id
  copy_count            = 1
  creation_start_at     = var.backup_start_time
  interval              = var.backup_interval
}
