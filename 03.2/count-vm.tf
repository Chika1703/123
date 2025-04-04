resource "twc_instance" "web" {
  count = 2

  name  = "web-${count.index + 1}"
  image = var.web_image_id
  plan  = var.web_plan

  # Привязываем к созданному firewall (если он используется для web-серверов)
  security_group_id = twc_firewall.security_firewall.id
  
  metadata = {
    ssh_key = var.vm_ssh_public_key
  }

  depends_on = [twc_instance.db]
}
