module "sol_ami_k8s" {
  source              = "./modules/ami"
  count               = var.k8s_ami_make ? 1 : 0
  ami_name            = join("-", ["${var.vpc_name}", "${var.system_type}", "k8s-ami"])
  for_ami_instance_id = module.sol_master_node[0].ec2_info.id
}