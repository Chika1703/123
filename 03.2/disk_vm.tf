resource "twc_disk" "storage_disk" {
  count = 3
  size  = 1  # размер в Гб
}

resource "twc_instance" "storage" {
  name  = "storage"
  image = var.storage_image_id
  plan  = var.storage_plan

  metadata = {
    ssh_key = var.vm_ssh_public_key
  }

  dynamic "secondary_disk" {
    for_each = twc_disk.storage_disk
    content {
      disk_id = secondary_disk.value.id
    }
  }
}
