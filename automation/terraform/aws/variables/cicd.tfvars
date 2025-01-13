# VPC
vpc_install = true
vpc_name = "cicd"
vpc_cidr = "10.0.0.0/16"
region   = "ap-northeast-2"

# # Subnet
# zone                = ["ap-northeast-2a"]
# subnet_public_cidr  = ["10.0.2.0/24"]
# subnet_private_cidr = ["10.0.3.0/24"]

<<<<<<< HEAD
# # EC2
# infra_count  = 1
# master_count = 1
# worker_count = 1

# # jumpbox vm
# bastion_image_code             = "ami-053171b6ca2943bce2"
# bastion_product_code           = "t2.medium" // vCPU 2EA, Memory 4GB
# bastion_root_block_device_size = 16

# # infra vm
# infra_image_code                 = "ami-053171b6ca2943bce"
# infra_product_code               = "t2.medium" // vCPU 2EA, Memory 4GB
# infra_root_block_device_size     = 50
# infra_ebs_root_block_device_size = 70

# # k8s master vm
# master_image_code                 = "ami-053171b6ca2943bce"
# master_product_code               = "t2.medium" // vCPU 2EA, Memory 4GB 
# master_root_block_device_size     = 50
# master_ebs_root_block_device_size = 70

# # k8s worker vm
# worker_image_code                 = "ami-053171b6ca2943bce"
# worker_product_code               = "t2.medium" // vCPU 2EA, Memory 4GB 
# worker_root_block_device_size     = 50
# worker_ebs_root_block_device_size = 70

# # template file
# infra_init    = "./templates/infra_init.tpl" //infra vm init template
# k8s_init      = "./templates/k8s_init.tpl"   //kubeadm master init template
# ansible_hosts = "./templates/hosts.tpl"      //kubeadm ansible host template
# ansible_vars  = "./templates/vars.tpl"       //kubeadm ansible vars template
=======
# EC2
infra_count  = 1
master_count = 1
worker_count = 1

//jumpbox vm
bastion_image_code             = "ami-053171b6ca2943bce2"
bastion_product_code           = "t2.medium" // vCPU 2EA, Memory 4GB
bastion_root_block_device_size = 16

//infra vm
infra_image_code                 = "ami-053171b6ca2943bce"
infra_product_code               = "t2.medium" // vCPU 2EA, Memory 4GB
infra_root_block_device_size     = 50
infra_ebs_root_block_device_size = 70

//k8s master vm
master_image_code                 = "ami-053171b6ca2943bce"
master_product_code               = "t2.medium" // vCPU 2EA, Memory 4GB 
master_root_block_device_size     = 50
master_ebs_root_block_device_size = 70

//k8s worker vm
worker_image_code                 = "ami-053171b6ca2943bce"
worker_product_code               = "t2.medium" // vCPU 2EA, Memory 4GB 
worker_root_block_device_size     = 50
worker_ebs_root_block_device_size = 70

//template file
infra_init    = "./templates/infra_init.tpl" //infra vm init template
k8s_init      = "./templates/k8s_init.tpl"   //kubeadm master init template
ansible_hosts = "./templates/hosts.tpl"      //kubeadm ansible host template
ansible_vars  = "./templates/vars.tpl"       //kubeadm ansible vars template
>>>>>>> e673fe4df3ccc9942fe5e49eb7bf0b9a267c3c53
