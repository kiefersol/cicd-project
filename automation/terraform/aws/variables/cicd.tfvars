# VPC
vpc_install = true
vpc_name    = "cicd"
vpc_cidr    = "10.0.0.0/16"
region      = "ap-northeast-2"

# Subnet
system_type         = "dev"
zone                = ["ap-northeast-2a"]
subnet_public_cidr  = ["10.0.1.0/24"]
subnet_private_cidr = ["10.0.2.0/24"]
nat_install         = true

# nas
nas_install                 = false
nas_infra_access_point      = "/mnt/nfs"
nas_kubernetes_access_point = "/"

# kubeadm 사용
k8s_manual_install            = true
k8s_ami_make                  = true
k8s_manual_worker_asg_install = true
k8s_nodeport                  = true


/*    
    Product code
    - vCPU 2EA, Memory 4GB : "t2.medium"
    - vCPU 2EA, Memory 16GB : "r5.large"
    - vCPU 4EA, Memory 16GB : "t3.xlarge"
    - vCPU 4EA, Memory 32GB : "r5.xlarge" 
    - vCPU 4EA, Memory 32GB, [SSD]Disk 150GB : "r5d.xlarge"  
    - vCPU 8EA, Memory 32GB : "t3.2xlarge"
    - vCPU 16EA, Memory 64GB, Disk 50GB : "m5.4xlarge"
*/

# EKS 사용
k8s_eks_install         = false
k8s_cluster_version     = "1.30" # eks는 1.* 까지만 입력
k8s_node_product_code   = "r5.large"
k8s_ng_root_volume_size = 50
k8s_ng_ebs_volume_size  = 70
k8s_node_worker_size = {
  desired = 1
  min     = 1
  max     = 2
}

# EC2
infra_count  = 1
master_count = 1
worker_count = 0

# jumpbox vm
bastion_image_code             = "ami-0a0cd2f78e9ef322a"
bastion_product_code           = "t2.medium" // vCPU 2EA, Memory 4GB
bastion_root_block_device_size = 16

# infra vm
infra_image_code                 = "ami-0a0cd2f78e9ef322a"
infra_product_code               = "t3.xlarge" // vCPU 4EA, Memory 16GB
infra_root_block_device_size     = 50
infra_ebs_root_block_device_size = 70

# infra lb
lb_infra_component_list                 = ["harbor", "gitlab", "nexus", "jenkins" ,"sonarqube", "mattermost"]
lb_infra_listener_port                  = [5443, 8443, 8081, 8080, 9000, 8085]
lb_infra_target_group_port              = [5443, 8443, 8081, 8080, 9000, 8085]
lb_infra_target_group_health_check_port = [5443, 8443, 8081, 8080, 9000, 8085]

k8s_version      = "1.30.1"
k8s_pod_cidr     = "20.0.0.0/10"
k8s_service_cidr = "25.0.0.0/16"

# k8s master vm
master_image_code                 = "ami-0a0cd2f78e9ef322a"
master_product_code               = "t3.xlarge" // vCPU 4EA, Memory 16GB
master_root_block_device_size     = 50
master_ebs_root_block_device_size = 10

# k8s worker vm
worker_image_code                 = "ami-0a0cd2f78e9ef322a"
worker_product_code               = "t3.xlarge" // vCPU 4EA, Memory 16GB
worker_root_block_device_size     = 50
worker_ebs_root_block_device_size = 10

# k8s lb
lb_k8s_component_list                 = ["k8s", "grafana", "kiali", "jaeger", "p8s", "istio","argocd", "argo-tls"]
lb_k8s_listener_port                  = [6443, 31020, 31030, 31050, 31060, 30080, 31080, 31081]
lb_k8s_target_group_port              = [6443, 31020, 31030, 31050, 31060, 30080, 31080, 31081]
lb_k8s_target_group_health_check_port = [6443, 31020, 31030, 31050, 31060, 30080, 31080, 31081]

# k8s auto scaling group
k8s_asg_product_code     = "t3.xlarge" // vCPU 4EA, Memory 16GB
k8s_asg_root_volume_size = 50
k8s_asg_ebs_volume_size  = 0
k8s_asg_max_size         = 1
k8s_asg_min_size         = 1
k8s_asg_desired_capacity = 1

# template file
infra_init    = "./templates/init_script/infra_init.tpl"   //infra vm init template
k8s_init      = "./templates/init_script/k8s_init.tpl"     //kubeadm init template
k8s_asg_init  = "./templates/init_script/k8s_asg_init.tpl" //kubeadm worker auto scaling group init template
k8s_ng_init   = "./templates/init_script/k8s_ng_init.tpl"
ansible_hosts = "./templates/hosts.tpl" //kubeadm ansible host template - ec2 worker
ansible_vars  = "./templates/vars.tpl"  //kubeadm ansible vars template

ansible_path = "/home/sol/cicd-project/automation"



