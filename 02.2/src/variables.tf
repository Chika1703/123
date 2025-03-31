variable "vm_web_name" {
  type    = string
  default = "netology-develop-platform-web"
}

variable "vm_web_image" {
  type    = string
  default = "ubuntu:20.04"
}

variable "vms_resources" {
  type = map(object({
    cpu_shares = number
    memory_mb  = number
    cpus       = number
  }))
  default = {
    web = {
      cpu_shares = 512
      memory_mb  = 1024
      cpus       = 1
    }
    db = {
      cpu_shares = 1024
      memory_mb  = 2048
      cpus       = 2
    }
  }
}

variable "metadata" {
  type = map(any)
  default = {
    restart_policy = "unless-stopped"
    stop_timeout   = 30
  }
}

variable "web_ssh_port" {
  type    = number
  default = 2222
}

variable "db_ssh_port" {
  type    = number
  default = 2223
}

variable "ssh_private_key_path" {
  type        = string
  description = "Path to the SSH private key"
  default     = "/home/chika/ter-homeworks/02.2/src/id_rsa"  
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to the SSH public key"
  default     = "/home/chika/ter-homeworks/02.2/src/id_rsa.pub"  
}

variable "ssh_volume" {
  type    = string
  default = "/root/.ssh"
}


# variable "vm_web_cpu_shares" {
#   type    = number
#   default = 512
# }

# variable "vm_web_memory" {
#   type    = number
#   default = 1024
# }

# variable "vm_db_cpu_shares" {
#   type    = number
#   default = 1024
# }

# variable "vm_db_memory" {
#   type    = number
#   default = 2048
# }

