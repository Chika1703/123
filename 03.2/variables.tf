variable "twc_token" {
  description = "API токен Timeweb Cloud"
  type        = string
  sensitive   = true
}

variable "vm_ssh_public_key" {
  description = "SSH публичный ключ для доступа к виртуальным машинам"
  type        = string
}

variable "availability_zone" {
  description = "Зона доступности для ресурсов"
  type        = string
  default     = "msk-1"
}

variable "local_network_id" {
  description = "ID приватной (локальной) сети"
  type        = string
  default     = ""
}

variable "servers" {
  description = "Список конфигураций серверов"
  type = list(object({
    name              = string
    preset_id         = number
    project_id        = number
    os_id             = number
    ssh_keys_ids      = list(number)
    floating_ip       = bool
    local_network_ip  = optional(string)
  }))
  default = [
    {
      name             = "Inventive Cepheus"
      preset_id        = 4795
      project_id       = 1407935
      os_id            = 79
      ssh_keys_ids     = [288185]
      floating_ip      = true
      local_network_ip = "192.168.0.4"
    },
    {
      name             = "Creative Orion"
      preset_id        = 4795
      project_id       = 1407935
      os_id            = 79
      ssh_keys_ids     = [288185]
      floating_ip      = false
      local_network_ip = "192.168.0.5"
    }
  ]
}

variable "backup_start_time" {
  description = "Время начала резервного копирования (в формате ISO)"
  type        = string
  default     = "2025-04-04T00:00:00.000Z"
}

variable "backup_interval" {
  description = "Интервал резервного копирования"
  type        = string
  default     = "day"
}

variable "web_preset_id" {
  description = "ID пресета для web серверов"
  type        = number
}

variable "webservers" {
  type = list(string)
  default = ["web-1", "web-2"]
}

variable "databases" {
  type = list(string)
  default = ["main", "replica"]
}

variable "storage" {
  type = string
  default = "storage"
}

variable "project_id" {
  description = "ID проекта"
  type        = number
}

variable "os_id" {
  description = "ID операционной системы"
  type        = number
}

variable "ssh_keys_ids" {
  description = "Список ID SSH-ключей"
  type        = list(number)
}