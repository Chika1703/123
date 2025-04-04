variable "twc_token" {
  type        = string
  sensitive   = true
  description = "API token for Timeweb Cloud"
}

variable "vm_ssh_public_key" {
  type        = string
  description = "SSH public key for VM access"
}

variable "vm_web_name" {
  type    = string
  default = "netology-develop-platform-web"
}

variable "vm_db_name" {
  type    = string
  default = "netology-develop-platform-db"
}

variable "vms_resources" {
  type = map(object({
    cpu = number
    ram = number
  }))
  default = {
    web = { cpu = 1, ram = 1024 }
    db  = { cpu = 2, ram = 2048 }
  }
}

# variable "vm_web_cpu" {
#  type    = number
#  default = 1
# }

# variable "vm_web_ram" {
#   type    = number
#   default = 1024
# }

# variable "vm_db_cpu" {
#   type    = number
#   default = 2
# }

# variable "vm_db_ram" {
#   type    = number
#   default = 2048
# }