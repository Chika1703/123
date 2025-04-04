locals {
  # Формируем список веб-серверов
  webservers = [
    for inst in twc_instance.web : {
      name = inst.name
      ip   = inst.public_ip
    }
  ]
  
  # Формируем список БД-серверов
  databases = [
    for inst in twc_instance.db : {
      name = inst.name
      ip   = inst.public_ip
    }
  ]
  
  # Данные для storage-сервера
  storage = {
    name = twc_instance.storage.name
    ip   = twc_instance.storage.public_ip
  }
  
  # Устанавливаем константный fqdn (при необходимости можно получать его из атрибутов ресурсов)
  fqdn = "cloud.timeweb.ru"
  
  inventory = templatefile("${path.module}/inventory.tftpl", {
    webservers = local.webservers
    databases  = local.databases
    storage    = local.storage
    fqdn       = local.fqdn
  })
}

resource "local_file" "ansible_inventory" {
  content  = local.inventory
  filename = "${path.module}/ansible_inventory.ini"
}
