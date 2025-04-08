[webservers]
%{ for i, dns in webservers_dns ~}
web-${i + 1} ansible_host=${dns}
%{ endfor ~}

%{ for i, ip in webservers_ips ~}
web-${i + 1} ansible_host=${ip}
%{ endfor ~}

[databases]
%{ for i, dns in database_dns ~}
db-${i + 1} ansible_host=${dns}
%{ endfor ~}

%{ for i, ip in database_ips ~}
db-${i + 1} ansible_host=${ip}
%{ endfor ~}

[storage]
storage ansible_host=${storage_dns}

storage ansible_host=${storage_ip}
