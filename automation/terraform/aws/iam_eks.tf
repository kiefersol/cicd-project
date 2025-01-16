# EKS
module "sol_iam_eks_role" {
  source           = "./modules/iam/role"
  count            = var.k8s_eks_install ? 1 : 0
  role_name        = join("-", ["${var.vpc_name}", "${var.system_type}", "eks_role"])
  role_policy_file = "./templates/iam/role_eks.tpl"
}

module "k8s-cluster-AmazonEKSClusterPolicy" {
  source     = "./modules/iam/policy_attachment"
  count      = var.k8s_eks_install ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role_name  = module.sol_iam_eks_role[0].iam_role_info.name
}

module "k8s-cluster-AmazonEKSServicePolicy" {
  source     = "./modules/iam/policy_attachment"
  count      = var.k8s_eks_install ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role_name  = module.sol_iam_eks_role[0].iam_role_info.name
}

module "k8s-cluster-AmazonEBSCSIDriverPolicy" {
  source     = "./modules/iam/policy_attachment"
  count      = var.k8s_eks_install ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role_name  = module.sol_iam_eks_role[0].iam_role_info.name
}

# Node Group
module "sol_iam_nodegroup_role" {
  source           = "./modules/iam/role"
  count            = var.k8s_nodegroup_install ? 1 : 0
  role_name        = join("-", ["${var.vpc_name}", "${var.system_type}", "worker", "role", "nodegroup"])
  role_policy_file = "./templates/iam/role_ec2.tpl"
}

module "sol_iam_nodegroup_policy" {
  source      = "./modules/iam/policy"
  count       = var.k8s_nodegroup_install ? 1 : 0
  policy_name = join("-", ["${var.vpc_name}", "${var.system_type}", "worker", "policy", "nodegroup"])
  policy_file = "./templates/iam/policy_worker_nodegroup.tpl"
}

module "k8s-worker-AmazonEKSWorkerNodePolicy" {
  source     = "./modules/iam/policy_attachment"
  count      = var.k8s_nodegroup_install ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role_name  = module.sol_iam_nodegroup_role[0].iam_role_info.name
}

module "k8s-worker-AmazonEKS_CNI_Policy" {
  source     = "./modules/iam/policy_attachment"
  count      = var.k8s_nodegroup_install ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role_name  = module.sol_iam_nodegroup_role[0].iam_role_info.name
}

module "k8s-worker-AmazonEC2ContainerRegistryReadOnly" {
  source     = "./modules/iam/policy_attachment"
  count      = var.k8s_nodegroup_install ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role_name  = module.sol_iam_nodegroup_role[0].iam_role_info.name
}

module "k8s-worker-AmazonAutoScailingPolicy" {
  source     = "./modules/iam/policy_attachment"
  count      = var.k8s_nodegroup_install ? 1 : 0
  policy_arn = module.sol_iam_nodegroup_policy[0].iam_policy_info.arn
  role_name  = module.sol_iam_nodegroup_role[0].iam_role_info.name
}


