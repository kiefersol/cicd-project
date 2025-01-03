module "tf_nic_public" {
  source    = "./modules/nic"
  count     = 1 # 무조건 1개 생성
  nic_desc  = "For Public Jumpbox VM NIC"
  subnet_id = module.sol_subnet_public[0].subnet_info.id
  acg_list  = [module.sol_jumpbox_sg.sg_info.id]
  nic_name  = join("-", ["${var.vpc_name}", "${count.index}", "jumpbox", "nic"])
  vpc_name  = var.vpc_name
}

module "tf_nic_private" {
  source    = "./modules/nic"
  count     = var.infra_count
  nic_desc  = "For Private Infra VM NIC"
  subnet_id = module.sol_subnet_private[count.index % length(var.zone)].subnet_info.id
  acg_list  = [module.sol_infra_sg.sg_info.id]
  nic_name  = join("-", ["${var.vpc_name}", "${count.index}", "infra", "nic"])
  vpc_name  = var.vpc_name
}

module "tf_nic_master" {
  source    = "./modules/nic"
  count     = var.master_count
  nic_desc  = "For kubernetes master VM NIC"
  subnet_id = module.sol_subnet_private[count.index % length(var.zone)].subnet_info.id
  acg_list  = [module.sol_master_sg.sg_info.id]
  nic_name  = join("-", ["${var.vpc_name}", "${count.index}", "master", "nic"])
  vpc_name  = var.vpc_name
}

module "tf_nic_worker" {
  source    = "./modules/nic"
  count     = var.worker_count
  nic_desc  = "For kubernetes worker VM NIC"
  subnet_id = module.sol_subnet_private[count.index % length(var.zone)].subnet_info.id
  acg_list  = [module.sol_worker_sg.sg_info.id]
  nic_name  = join("-", ["${var.vpc_name}", "${count.index}", "worker", "nic"])
  vpc_name  = var.vpc_name
}