terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${path.module}/id_rsa"
}

resource "local_file" "public_key" {
  content  = tls_private_key.ssh_key.public_key_openssh
  filename = "${path.module}/id_rsa.pub"
}

resource "docker_container" "web" {
  name          = local.vm_web_name
  image         = var.vm_web_image
  cpu_shares    = var.vms_resources.web.cpu_shares
  memory        = var.vms_resources.web.memory_mb
  restart       = var.metadata.restart_policy
  stop_timeout  = var.metadata.stop_timeout
  command = ["bash", "-c", "apt-get update && apt-get install -y openssh-server && mkdir -p /root/.ssh && echo \"${tls_private_key.ssh_key.public_key_openssh}\" >> /root/.ssh/authorized_keys && mkdir -p /run/sshd && chmod 755 /run/sshd && /usr/sbin/sshd -D"]

  ports {
    internal = 22
    external = var.web_ssh_port
  }

  volumes {
    host_path      = var.ssh_volume
    container_path = "/root/.ssh"
  }

  volumes {
    host_path      = var.ssh_private_key_path
    container_path = "/root/.ssh/id_rsa"
  }

  volumes {
    host_path      = var.ssh_public_key_path
    container_path = "/root/.ssh/id_rsa.pub"
  }
}

resource "docker_container" "db" {
  name          = local.vm_db_name
  image         = var.vm_db_image
  cpu_shares    = var.vms_resources.db.cpu_shares
  memory        = var.vms_resources.db.memory_mb
  restart       = var.metadata.restart_policy
  stop_timeout  = var.metadata.stop_timeout
  command = ["bash", "-c", 
"apt-get update && apt-get install -y openssh-server && mkdir -p /root/.ssh && echo \"${tls_private_key.ssh_key.public_key_openssh}\" >> /root/.ssh/authorized_keys && mkdir -p /run/sshd && chmod 755 /run/sshd && /usr/sbin/sshd -D"
  ]

  ports {
    internal = 22
    external = var.db_ssh_port
  }

  volumes {
    host_path      = var.ssh_volume
    container_path = "/root/.ssh"
  }

  volumes {
    host_path      = var.ssh_private_key_path
    container_path = "/root/.ssh/id_rsa"
  }

  volumes {
    host_path      = var.ssh_public_key_path
    container_path = "/root/.ssh/id_rsa.pub"
  }
}
