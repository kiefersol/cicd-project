## IAM Role and policy for kubernetes master 
module "sol_iam_master_role" {
  source           = "./modules/iam/role"
  count            = var.k8s_manual_install ? 1 : 0
  role_name        = join("-", ["${var.vpc_name}", "${var.system_type}", "master_role"])
  role_policy_file = "./templates/iam/role_ec2.tpl"
}

module "sol_iam_master_policy" {
  source      = "./modules/iam/policy"
  count       = var.k8s_manual_install ? 1 : 0
  policy_name = join("-", ["${var.vpc_name}", "${var.system_type}", "master_policy"])
  policy_file = "./templates/iam/policy_master_ec2.tpl"
}

module "sol_iam_master_policy_attachment" {
  source     = "./modules/iam/policy_attachment"
  count      = var.k8s_manual_install ? 1 : 0
  policy_arn = module.sol_iam_master_policy[0].iam_policy_info.arn
  role_name  = module.sol_iam_master_role[0].iam_role_info.name
}

module "sol_iam_master_profile" {
  source       = "./modules/iam/profile"
  count        = var.k8s_manual_install ? 1 : 0
  profile_name = join("-", ["${var.vpc_name}", "${var.system_type}", "master_profile"])
  role_name    = module.sol_iam_master_role[0].iam_role_info.name
}

## IAM Role and policy for worker ec2
module "sol_iam_worker_role_ec2" {
  source           = "./modules/iam/role"
  count            = var.worker_count > 0 ? 1 : 0
  role_name        = join("-", ["${var.vpc_name}", "${var.system_type}", "worker_role", "ec2"])
  role_policy_file = "./templates/iam/role_ec2.tpl"
}

module "sol_iam_worker_policy_ec2" {
  source      = "./modules/iam/policy"
  count       = var.worker_count > 0 ? 1 : 0
  policy_name = join("-", ["${var.vpc_name}", "${var.system_type}", "worker_policy", "ec2"])
  policy_file = "./templates/iam/policy_worker_ec2.tpl"
}

module "sol_iam_worker_policy_attachment_ec2" {
  source     = "./modules/iam/policy_attachment"
  count      = var.worker_count > 0 ? 1 : 0
  policy_arn = module.sol_iam_worker_policy_ec2[0].iam_policy_info.arn
  role_name  = module.sol_iam_worker_role_ec2[0].iam_role_info.name
}

module "sol_iam_worker_profile_ec2" {
  source       = "./modules/iam/profile"
  count        = var.worker_count > 0 ? 1 : 0
  profile_name = join("-", ["${var.vpc_name}", "${var.system_type}", "worker_profile", "ec2"])
  role_name    = module.sol_iam_worker_role_ec2[0].iam_role_info.name
}

## IAM Role and policy for Auto Scaling Group
module "sol_iam_worker_role_asg" {
  source           = "./modules/iam/role"
  count            = var.k8s_manual_worker_asg_install ? 1 : 0
  role_name        = join("-", ["${var.vpc_name}", "${var.system_type}", "worker_role", "asg"])
  role_policy_file = "./templates/iam/role_ec2.tpl"
}

module "sol_iam_worker_policy_asg" {
  source      = "./modules/iam/policy"
  count       = var.k8s_manual_worker_asg_install ? 1 : 0
  policy_name = join("-", ["${var.vpc_name}", "${var.system_type}", "worker_policy", "asg"])
  policy_file = "./templates/iam/policy_worker_asg.tpl"
}

module "sol_iam_worker_policy_attachment_asg" {
  source     = "./modules/iam/policy_attachment"
  count      = var.k8s_manual_worker_asg_install ? 1 : 0
  policy_arn = module.sol_iam_worker_policy_asg[0].iam_policy_info.arn
  role_name  = module.sol_iam_worker_role_asg[0].iam_role_info.name
}

module "sol_iam_worker_profile_asg" {
  source       = "./modules/iam/profile"
  count        = var.k8s_manual_worker_asg_install ? 1 : 0
  profile_name = join("-", ["${var.vpc_name}", "${var.system_type}", "worker_profile", "asg"])
  role_name    = module.sol_iam_worker_role_asg[0].iam_role_info.name
}