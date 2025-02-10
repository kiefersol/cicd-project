%{ for i in range(signum(infra_count)) ~}

%{ for i in range(infra_count) ~}
[infra${i+1}]
${infra_ip[i]}
%{ endfor ~}

[infra:children]
%{ for i in range(infra_count) ~}
infra${i+1}
%{ endfor ~}

%{ endfor ~}

%{ for i in range(signum(master_count)) ~}

%{ for i in range(master_count) ~}
[master${i+1}]
${master_ip[i]}
%{ endfor ~}

%{ for i in range(signum(master_count - 1)) ~}
[sub-master:children]
%{ endfor ~}
%{ for i in range(max(master_count -1, 0)) ~}
master{i+2}
%{ endfor ~}

[master:children]
%{ for i in range(master_count) ~}
master${i+1}
%{ endfor ~}

%{ endfor ~}

%{ for i in range(signum(worker_count)) ~}

%{ for i in range(worker_count) ~}
[worker${i+1}]
${worker_ip[i]}
%{ endfor ~}

[worker:children]
%{ for i in range(worker_count) ~}
worker${i+1}
%{ endfor ~}

%{ endfor ~}

[gitlab:children]
infra1
[harbor:children]
infra1
[jenkins:children]
infra1
[portal:children]
infra1
[nas:children]
infra1
[nexus:children]
infra1
[kafka:children]
infra1
[ldap:children]
infra1
[mattermost:children]
infra1
[sonarqube:children]
infra1
[mysql:children]
infra1

%{ for i in range(signum(infra_count)) ~}
[infra:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand="ssh -W %h:%p -q sol@${jumpbox_ip}"'
%{ endfor ~}

%{ for i in range(signum(master_count)) ~}
[master:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand="ssh -W %h:%p -q sol@${jumpbox_ip}"'
%{ endfor ~}

%{ for i in range(signum(worker_count)) ~}
[worker:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand="ssh -W %h:%p -q sol@${jumpbox_ip}"'
%{ endfor ~}



