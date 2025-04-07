[webservers]
%{ for ip in webservers_ips ~}
web ansible_host=${ip}
%{ endfor ~}

[storage]
storage ansible_host=${storage_ip}
