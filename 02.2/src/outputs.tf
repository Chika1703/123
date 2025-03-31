output "vm_instances" {
  value = {
    web = {
      name = docker_container.web.name
      ip   = docker_container.web.network_data[0].ip_address
    }
    db = {
      name = docker_container.db.name
      ip   = docker_container.db.network_data[0].ip_address
    }
  }
}

output "private_key_path" {
  value = local_file.private_key.filename
}

output "public_key_path" {
  value = local_file.public_key.filename
}

output "public_key" {
  value = tls_private_key.ssh_key.public_key_openssh
}

