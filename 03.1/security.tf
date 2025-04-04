# Создание фаервола
resource "twc_firewall" "example" {
  name        = "example-firewall"
  description = "Разрешает SSH-доступ"
}

# Правило для SSH (IPv4)
resource "twc_firewall_rule" "allow_ssh" {
  firewall_id = twc_firewall.example.id
  direction   = "ingress"
  protocol    = "tcp"
  port        = 22
  cidr        = "0.0.0.0/0" 
}
