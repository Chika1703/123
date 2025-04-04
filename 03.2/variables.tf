variable "twc_token" {
  description = "Token для доступа к Timeweb.Cloud"
  type        = string
}

variable "vm_ssh_public_key" {
  description = "Публичный SSH ключ"
  type        = string
}

variable "local_network_id" {
  description = "ID локальной сети"
  type        = string
}

# Параметры для веб-серверов
variable "web_image_id" {
  description = "ID образа для веб-серверов"
  type        = string
}

variable "web_plan" {
  description = "Тариф/план для веб-серверов"
  type        = string
}

# Параметры для БД-серверов
variable "db_image_id" {
  description = "ID образа для БД-серверов"
  type        = string
}

variable "db_plan" {
  description = "Тариф/план для БД-серверов"
  type        = string
}

# Параметры для storage-сервера
variable "storage_image_id" {
  description = "ID образа для storage-сервера"
  type        = string
}

variable "storage_plan" {
  description = "Тариф/план для storage-сервера"
  type        = string
}

# Переменная для создания ВМ через for_each (БД-сервера)
variable "each_vm" {
  description = "Список объектов для создания БД-серверов"
  type = list(object({
    vm_name     = string
    cpu         = number
    ram         = number
    disk_volume = number
  }))
}
