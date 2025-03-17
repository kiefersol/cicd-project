cloud_provider: ${cloud_provider} # aws, awsM

ansible_path : "${ansible_path}"

vpc_name : ${vpc_name}
region_name: ${region}
system_type: ${system_type}
access_key: ${access_key} 
secret_key: ${secret_key} 
jumpbox_ip: ${jumpbox_ip}
infra_lb_domain: ${infra_lb_domain_name} 
k8s_lb_domain: ${k8s_lb_domain_name} 
infra_ip: ${infra_ip} 
jenkins_ip :  "{{infra_lb_domain}}"
kafka_ip : "{{infra_lb_domain}}"
harbor_ip : "{{infra_lb_domain}}"
gitlab_ip :  "{{infra_lb_domain}}"

nfs_path: ${nas_path}
nfs_name: ${nas_name}
nfs_dns: ${nas_dns}
nas_mount_path: "${nas_mount_path}"

nfs_server: ${nas_server}
nfs_mountoptions: nfsvers=${nas_mountoptions}
nfs_pvc_name: solpv

ec2_ebs_mount_path : "/app"

k8s_multi_master: %{if (master_count)==1}false%{else}true%{endif}
kube_config: "/home/sol/.kube/${vpc_name}-${system_type}-config"

docker_version: "25.0.2"
docker_bip: 7.7.128.1/18
docker_pools_base: 7.7.192.0/18
docker_log_max_size : 10m
docker_log_max_file : 2
docker_root_dir : /var/lib/docker
# docker_root_dir : "{{ec2_ebs_mount_path}}/docker"

containerd_version : "1.6.28"
containerd_root_dir: /var/lib/containerd
# containerd_root_dir: {{ec2_ebs_mount_path}}/contianerd
kubelet_containerLogMaxSize : 10Mi
kubelet_containerLogMaxFiles : 2

install_shell_dir : "/home/sol/install_shell"

harbor_host: registry.sol.lab
harbor_http_port: 5000
harbor_https_port: 5443
harbor_ssl: true
harbor_ssl_path : /home/sol/.ssl/
harbor_cert_path: /home/sol/.ssl/harbor/harbor.pem
harbor_key_path: /home/sol/.ssl/harbor/harbor-key.pem
harbor_install_dir: /home/sol/harbor/install
harbor_data_dir: /home/sol/harbor/data 
harbor_log_dir: /home/sol/harbor/log
harbor_username: sol
harbor_password: solsol1234!
harbor_cert_CN: registry.sol.lab
harbor_cert_hosts: "\"registry.sol.lab\", \"{{infra_lb_domain}}\""

gitlab_host: gitlab.sol.lab
gitlab_external_url: https://{{infra_lb_domain}}:{{gitlab_port}}
gitlab_http_port: 18080
gitlab_https_port: 8443
gitlab_config_dir: /home/sol/gitlab/config
gitlab_install_dir: /home/sol/gitlab/
gitlab_data_dir: /home/sol/gitlab/data
gitlab_log_dir: /home/sol/gitlab/logs
gitlab_ssl_dir: /home/sol/gitlab/config/ssl
gitlab_root_username: sol
gitlab_password: solsol1234!
gitlab_cert_CN: "{{infra_lb_domain}}"
gitlab_ssl: true
gitlab_cert_hosts: "\"gitlab.sol.lab\", \"{{infra_lb_domain}}\""
gitlab_memory: "4g"
gitlab_cpu: 2

jenkins_dir : /home/sol/jenkins
jenkins_port: 8080
jenkins_agent_port: 50000
jenkins_memory: 2g
jenkins_version: 2.444

crictl_version : v1.30.0
nerdctl_version : 1.7.3

asg_min_size : ${asg_min_size}
asg_max_size : ${asg_max_size}

k8s_pause_version : 3.6 
node_status_update_frequency_second : 5     #/var/lib/kubelet/kubeadm-flags.env
node_monitor_period_second : 10
node_monitor_grace_period_second : 15
default_not_ready_toleration_seconds: 5
default_unreachable_toleration_seconds: 5

kubernetes_version : ${k8s_version}
kubernetes_pod_cidr : ${k8s_pod_cidr}
kubernetes_service_cidr : ${k8s_service_cidr}
kubernetes_service_type : ${k8s_service_type}
k8s_cluster_autoscaler_version : 1.30

k8s_api_ip : "{{k8s_lb_domain}}"  # ip 수정
k8s_api_port : 6443
master_ip : ${master_ip[0]}%{ for i in range((master_count)-1) ~},${master_ip[i+1]}%{ endfor ~}

k8s_cert_svc_ip : 25.0.0.1  # k8s service cidr값의 첫번째 ip

nginx_ssl : false
nginx_cert_CN: "{{infra_lb_domain}}"
nginx_cert_hosts: "\"jenkins.sol.lab\",\"monitoring.sol.lab\", \"{{infra_lb_domain}}\""  
nginx_dir : /home/sol/nginx
nginx_dir_conf : /home/sol/nginx/conf.d

kafka1_dir: /home/sol/automation/kafka/kafka1
kafka2_dir: /home/sol/automation/kafka/kafka2
kafka3_dir: /home/sol/automation/kafka/kafka3
zookeeper_dir: /home/sol/automation/kafka/zookeeper

trivy_db_dir: /home/sol/trivy

nexus_port: 8081
nexus_data_dir: /home/sol/nexus

mattermost_port : 8085
mattermost_dir : /home/sol/mattermost
mattermost_data_dir : /home/sol/mattermost/volumes

sonarqube_mysql_dir : /home/sol/sonarqube_mysql
sonarqube_mysql_port: 3305
sonarqube_port: 9000

mysql_dir : /home/sol/mysql
mysql_port : 3306