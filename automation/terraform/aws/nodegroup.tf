module "sol_nodegroup_init_script" {
  source                  = "./modules/nodegroup/launch_template"
  count                   = var.k8s_eks_install ? 1 : 0
  nodegroup_template_name = join("-", ["${var.vpc_name}", "${var.system_type}", "worker", "nodegroup", "init_script"])
  k8s_ng_init_script      = var.k8s_ng_init
  infra_node_ip           = module.sol_infra_node[0].ec2_info.private_ip
  login_key_name          = aws_key_pair.sol_loginkey.key_name
  nodegroup_instance_type = var.k8s_node_product_code
  ng_volume_size          = var.k8s_ng_root_volume_size
  ng_ebs_volume_size      = var.k8s_ng_ebs_volume_size
  security_groups         = [module.sol_nodegroup_sg[0].sg_info.id]
}

module "sol_nodegroup" {
  source                                        = "./modules/nodegroup/nodegroup"
  count                                         = var.k8s_eks_install ? 1 : 0
  eks_name                                      = module.sol_eks_cluster[0].eks_info.name
  nodegroup_name                                = join("-", ["${var.vpc_name}", "${var.system_type}", "worker", "nodegroup"])
  nodegroup_role_arn                            = module.sol_nodegroup_role[0].iam_role_info.arn
  nodegroup_subnet_ids                          = [for subnet in module.sol_subnet_private : subnet.subnet_info.id] # 서브넷 2개 이상 필요
  nodegroup_launch_template_name                = module.sol_nodegroup_init_script[0].nodegroup_launch_template_info.name
  nodegroup_scaling_desired                     = var.k8s_node_worker_size.desired
  nodegroup_scaling_min                         = var.k8s_node_worker_size.min
  nodegroup_scaling_max                         = var.k8s_node_worker_size.max
  eks_policy_AmazonEKSWorkerNodePolicy          = module.k8s-worker-AmazonEKSWorkerNodePolicy[0].iam_policy_attachment_info.policy_arn
  eks_policy_AmazonEKS_CNI_Policy               = module.k8s-worker-AmazonEKS_CNI_Policy[0].iam_policy_attachment_info.policy_arn
  eks_policy_AmazonEC2ContainerRegistryReadOnly = module.k8s-worker-AmazonEC2ContainerRegistryReadOnly[0].iam_policy_attachment_info.policy_arn
  eks_policy_AmazonAutoScailingPolicy           = module.k8s-worker-AmazonAutoScailingPolicy[0].iam_policy_attachment_info.policy_arn
  vpc_name                                      = var.vpc_name
  system_type                                   = var.system_type
}

