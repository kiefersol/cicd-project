module "sol_nic_public" {
  source          = "./modules/nic"
  count           = length(var.zone)
  description     = "For Public Jumpbox VM NIC"
  subnet_id       = module.sol_subnet_public[count.index % length(var.zone)].subnet_info.id
  security_groups = [module.sol_jumpbox_sg.sg_info.id]
  nic_name        = join("-", ["${var.vpc_name}", "${var.system_type}", "${count.index}", "jumpbox", "nic"])
  vpc_name        = var.vpc_name
  system_type     = var.system_type
}

module "sol_nic_private" {
  source          = "./modules/nic"
  count           = var.infra_count
  description     = "For Private Infra VM NIC"
  subnet_id       = module.sol_subnet_private[count.index % length(var.zone)].subnet_info.id
  security_groups = [module.sol_infra_sg[0].sg_info.id]
  nic_name        = join("-", ["${var.vpc_name}", "${var.system_type}", "${count.index}", "infra", "nic"])
  vpc_name        = var.vpc_name
  system_type     = var.system_type
}

module "sol_nic_master" {
  source          = "./modules/nic"
  count           = var.k8s_manual_install ? var.master_count : 0
  description     = "For kubernetes master VM NIC"
  subnet_id       = module.sol_subnet_private[count.index % length(var.zone)].subnet_info.id
  security_groups = [module.sol_master_sg[0].sg_info.id]
  nic_name        = join("-", ["${var.vpc_name}", "${var.system_type}", "${count.index}", "master", "nic"])
  vpc_name        = var.vpc_name
  system_type     = var.system_type
}

module "sol_nic_worker" {
  source          = "./modules/nic"
  count           = var.k8s_manual_install ? var.worker_count : 0
  description     = "For kubernetes worker VM NIC"
  subnet_id       = module.sol_subnet_private[count.index % length(var.zone)].subnet_info.id
  security_groups = [module.sol_worker_ec2_sg[0].sg_info.id]
  nic_name        = join("-", ["${var.vpc_name}", "${var.system_type}", "${count.index}", "worker", "nic"])
  vpc_name        = var.vpc_name
  system_type     = var.system_type
}