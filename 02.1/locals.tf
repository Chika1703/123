locals {
  vm_web_full_name = "${var.vm_web_name}-${terraform.workspace}"
  vm_db_full_name  = "${var.vm_db_name}-${terraform.workspace}"
}