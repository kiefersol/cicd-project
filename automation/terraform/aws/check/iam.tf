## IAM Role and policy for kubernetes master 
module "sol_iam_master_role" {
  source           = "./modules/iam/role"
  count            = var.master_count > 1 ? 1 : 0
  role_name        = join("-", ["${var.vpc_name}", "master_role"])
  role_policy_file = "./template/iam/role_ec2.tpl"
}

module "sol_iam_master_policy" {
  source      = "./modules/iam/policy"
  count       = var.master_count > 1 ? 1 : 0
  policy_name = join("-", ["${var.vpc_name}", "master_policy"])
  policy_file = "./template/iam/policy_master_ec2.tpl"
}

module "sol_iam_master_policy_attachment" {
  source     = "./modules/iam/policy_attachment"
  count      = var.master_count > 1 ? 1 : 0
  policy_arn = module.sol_iam_master_policy[0].iam_policy_info.arn
  role_name  = module.sol_iam_master_role[0].iam_role_info.name
}

module "sol_iam_master_profile" {
  source       = "./modules/iam/profile"
  count        = var.master_count > 1 ? 1 : 0
  profile_name = join("-", ["${var.vpc_name}", "master_profile"])
  role_name    = module.sol_iam_master_role[0].iam_role_info.name
}

## IAM Role and policy for Auto Scaling Group
module "sol_iam_worker_role" {
  source           = "./modules/iam/role"
  count            = var.worker_count > 1 ? 1 : 0
  role_name        = join("-", ["${var.vpc_name}", "worker_role"])
  role_policy_file = "./template/iam/role_ec2.tpl"
}

module "sol_iam_worker_policy" {
  source      = "./modules/iam/policy"
  count       = var.worker_count > 1 ? 1 : 0
  policy_name = join("-", ["${var.vpc_name}", "worker_policy"])
  policy_file = "./template/iam/policy_worker_ec2.tpl"
}

module "sol_iam_worker_policy_attachment" {
  source     = "./modules/iam/policy_attachment"
  count      = var.worker_count > 1 ? 1 : 0
  policy_arn = module.sol_iam_worker_policy[0].iam_policy_info.arn
  role_name  = module.sol_iam_worker_role[0].iam_role_info.name
}

module "sol_iam_worker_profile" {
  source       = "./modules/iam/profile"
  count        = var.worker_count > 1 ? 1 : 0
  profile_name = join("-", ["${var.vpc_name}", "worker_profile"])
  role_name    = module.sol_iam_worker_role[0].iam_role_info.name
}