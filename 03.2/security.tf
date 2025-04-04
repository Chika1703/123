resource "twc_firewall" "security_firewall" {
  name        = "security-firewall"
  description = "Фаервол для управления доступом"

  # Динамический блок link связывает фаервол со всеми серверами, созданными ресурсом twc_server.web
  dynamic "link" {
    for_each = toset(twc_server.web[*].id)
    content {
      id   = link.value
      type = "server"
    }
  }
}

resource "twc_firewall_rule" "security_allow_ssh" {
  firewall_id = twc_firewall.security_firewall.id
  direction   = "ingress"
  protocol    = "tcp"
  port        = 22
  cidr        = "0.0.0.0/0"
}
