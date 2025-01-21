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
nas_install                 = true
nas_infra_access_point      = "/mnt/nfs"
nas_kubernetes_access_point = "/"

# eks 사용
k8s_eks_install       = false
k8s_nodegroup_install = false

# eks 사용하지 않고 kubeadm 사용
k8s_manual_install            = true
k8s_ami_make                  = false
k8s_manual_worker_asg_install = false

# EC2
infra_count  = 1
master_count = 1
worker_count = 1

# jumpbox vm
bastion_image_code             = "ami-053171b6ca2943bce2"
bastion_product_code           = "t2.medium" // vCPU 2EA, Memory 4GB
bastion_root_block_device_size = 16

# infra vm
infra_image_code                 = "ami-053171b6ca2943bce"
infra_product_code               = "t2.medium" // vCPU 2EA, Memory 4GB
infra_root_block_device_size     = 50
infra_ebs_root_block_device_size = 70

# infra lb
lb_infra_component_list                 = ["harbor", "gitlab", "nexus", "jenkins"]
lb_infra_listener_port                  = [5443, 8443, 8081, 8080]
lb_infra_target_group_port              = [5443, 8443, 8081, 8080]
lb_infra_target_group_health_check_port = [5443, 8443, 8081, 8080]

# k8s master vm
master_image_code                 = "ami-053171b6ca2943bce"
master_product_code               = "t2.medium" // vCPU 2EA, Memory 4GB 
master_root_block_device_size     = 50
master_ebs_root_block_device_size = 70

# k8s worker vm
worker_image_code                 = "ami-053171b6ca2943bce"
worker_product_code               = "t2.medium" // vCPU 2EA, Memory 4GB 
worker_root_block_device_size     = 50
worker_ebs_root_block_device_size = 70

# k8s lb
lb_k8s_component_list                 = ["k8s"]
lb_k8s_listener_port                  = [6443]
lb_k8s_target_group_port              = [6443]
lb_k8s_target_group_health_check_port = [6443]

# template file
infra_init    = "./templates/infra_init.tpl" //infra vm init template
k8s_init      = "./templates/k8s_init.tpl"   //kubeadm master init template
ansible_hosts = "./templates/hosts.tpl"      //kubeadm ansible host template
ansible_vars  = "./templates/vars.tpl"       //kubeadm ansible vars template



