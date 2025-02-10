module "sol_worker_asg_template" {
  source                        = "./modules/asg/launch_template"
  count                         = var.k8s_manual_worker_asg_install ? 1 : 0
  asg_template_name             = join("-", ["${var.vpc_name}", "${var.system_type}", "worker", "asg", "init_script"])
  asg_init_script               = var.k8s_asg_init
  master_node_ip                = module.sol_master_node[0].ec2_info.private_ip
  k8s_lb                        = module.sol_lb_k8s[0].lb_info.dns_name
  asg_login_key_name            = aws_key_pair.sol_loginkey.key_name
  asg_image_code                = module.sol_ami_k8s[0].ami_info.id
  asg_product_code              = var.k8s_asg_product_code
  asg_security_groups           = [module.sol_worker_asg_sg[0].sg_info.id]
  asg_iam_instance_profile_name = module.sol_iam_worker_profile_asg[0].iam_profile_info.name
  asg_volume_size               = var.k8s_asg_root_volume_size
  asg_ebs_volume_size           = var.k8s_asg_ebs_volume_size
}

module "sol_worker_asg" {
  source               = "./modules/asg/asg"
  count                = var.k8s_manual_worker_asg_install ? 1 : 0
  asg_name             = join("-", ["${var.vpc_name}", "${var.system_type}", "worker", "asg"])
  asg_subnet_ids       = [for i in range(length(var.zone)) : module.sol_subnet_private[i].subnet_info.id]
  asg_max_size         = var.k8s_asg_max_size
  asg_min_size         = var.k8s_asg_min_size
  asg_desired_capacity = var.k8s_asg_desired_capacity
  target_group_list    = var.k8s_nodeport ? [for i in range(length(var.lb_k8s_component_list)) : module.sol_lb_k8s_target_group[i].lb_target_group_info.arn] : []
  asg_template_id      = module.sol_worker_asg_template[0].asg_launch_template_info.id
  vpc_name             = var.vpc_name
  system_type          = var.system_type
}
