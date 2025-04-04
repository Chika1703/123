resource "twc_instance" "db" {
  for_each = { for vm in var.each_vm : vm.vm_name => vm }
  
  name      = each.value.vm_name
  cpu       = each.value.cpu
  ram       = each.value.ram
  disk_size = each.value.disk_volume
  image     = var.db_image_id
  plan      = var.db_plan
  
  metadata = {
    ssh_key = var.vm_ssh_public_key
  }
}
