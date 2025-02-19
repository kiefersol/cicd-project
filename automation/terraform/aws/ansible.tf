module "hosts" {
  source         = "./modules/ansible/hosts"
  count          = var.k8s_manual_install ? 1 : 0
  template_file  = var.ansible_hosts
  jumpbox_ip     = module.sol_eip_for_ec2[0].eip_info.public_ip
  infra_ips      = [for info in module.sol_infra_node : info.ec2_info.private_ip]
  infra_count    = var.infra_count
  master_ips     = [for info in module.sol_master_node : info.ec2_info.private_ip]
  master_count   = var.master_count
  worker_ips     = [for info in module.sol_worker_node : info.ec2_info.private_ip]
  worker_count   = var.worker_count
  inventory_file = "${var.ansible_path}/ansible/inventory/hosts_aws_${var.vpc_name}_${var.system_type}"
}

module "vars" {
  source               = "./modules/ansible/vars"
  count                = var.k8s_manual_install ? 1 : 0
  template_file        = var.ansible_vars
  cloud_provider       = var.k8s_manual_install ? "manual" : "eks"
  nas_server           = var.nas_install ? module.sol_efs_mount_target[0].efs_mount_target_info.ip_address : module.sol_infra_node[0].ec2_info.private_ip
  nas_path             = var.nas_install ? join("", [module.sol_efs_mount_target[0].efs_mount_target_info.ip_address, ":/"]) : "/home/sol/nfs"
  nas_name             = var.nas_install ? module.sol_efs[0].efs_info.id : ""
  nas_dns              = var.nas_install ? module.sol_efs[0].efs_info.dns_name : ""
  nas_mount_path       = var.nas_install ? var.nas_infra_access_point : ""
  nas_mountoptions     = var.nas_install ? "4.1" : "4"
  region               = var.region
  access_key           = var.access_key
  secret_key           = var.secret_key
  system_type          = var.system_type
  jumpbox_ip           = module.sol_eip_for_ec2[0].eip_info.public_ip
  infra_lb_domain_name = module.sol_lb_infra[0].lb_info.dns_name
  k8s_lb_domain_name   = module.sol_lb_k8s[0].lb_info.dns_name
  infra_ip             = module.sol_infra_node[0].ec2_info.private_ip
  vpc_id               = data.aws_vpc.vpc_info.id
  vpc_name             = var.vpc_name
  k8s_version          = var.k8s_version
  vars_file            = "${var.ansible_path}/ansible/playbooks/vars-aws-${var.vpc_name}-${var.system_type}.yaml"
  asg_min_size         = var.k8s_asg_min_size
  asg_max_size         = var.k8s_asg_max_size
  k8s_pod_cidr         = var.k8s_pod_cidr
  k8s_service_cidr     = var.k8s_service_cidr
  k8s_service_type     = var.k8s_nodeport ? "nodeport" : "loadbalancer"
  master_count         = var.master_count
  master_ips           = [for info in module.sol_master_node : info.ec2_info.private_ip]
  ansible_path         = "${var.ansible_path}/ansible"
}

