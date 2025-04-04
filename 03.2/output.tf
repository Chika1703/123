output "instances" {
  value = flatten([
    [for inst in twc_instance.web : {
      name = inst.name
      id   = inst.id
      fqdn = inst.fqdn
    }],
    [for inst in twc_instance.db : {
      name = inst.name
      id   = inst.id
      fqdn = inst.fqdn
    }],
    [{
      name = twc_instance.storage.name
      id   = twc_instance.storage.id
      fqdn = twc_instance.storage.fqdn
    }]
  ])
}
