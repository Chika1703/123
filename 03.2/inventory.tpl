[webservers]
%{ for server in webservers ~}
${server} ansible_host=<external_ip> fqdn=<fqdn>
%{ endfor ~}

[databases]
%{ for db in databases ~}
${db} ansible_host=<external_ip> fqdn=<fqdn>
%{ endfor ~}

[storage]
${storage} ansible_host=<external_ip> fqdn=<fqdn>
