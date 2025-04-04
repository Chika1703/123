variable "twc_token" {
  description = "Timeweb Cloud API token"
  type        = string
  sensitive   = true
}

variable "vm_ssh_public_key" {
  description = "SSH public key для доступа к VM"
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

variable "cloud_id" {
  description = "Cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Идентификатор папки"
  type        = string
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
    // Опциональное поле для указания IP в локальной сети (если сервер подключается к приватной сети)
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
