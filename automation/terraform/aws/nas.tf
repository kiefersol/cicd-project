module "sol_efs" {
  source               = "./modules/nas/efs"
  count                = var.nas_install ? 1 : 0
  efs_token_name       = join("-", ["${var.vpc_name}", "${var.system_type}", "efs"])
  efs_name             = join("-", ["${var.vpc_name}", "${var.system_type}", "efs"])
  efs_encrypted        = false
  efs_performance_mode = "generalPurpose"
  efs_throughput_mode  = "bursting"
  vpc_name             = var.vpc_name
  system_type          = var.system_type
}

module "sol_efs_mount_target" {
  source    = "./modules/nas/efs_mount_target"
  count     = length(var.zone)
  efs_id    = module.sol_efs[0].efs_info.id
  subnet_id = module.sol_subnet_private[count.index].subnet_info.id
  sg_id     = [module.sol_nas_sg[0].sg_info.id]
}

module "sol_efs_access_point_infra" {
  source                = "./modules/nas/efs_access_point"
  efs_id                = module.sol_efs[0].efs_info.id
  efs_path              = var.nas_infra_access_point
  efs_gid               = "0"
  efs_uid               = "0"
  efs_permissions       = "0755"
  efs_access_point_name = join("-", ["${var.vpc_name}", "${var.system_type}", "infra", "efs"])
  vpc_name              = var.vpc_name
  system_type           = var.system_type
}

module "sol_efs_access_point_k8s" {
  source                = "./modules/nas/efs_access_point"
  efs_id                = module.sol_efs[0].efs_info.id
  efs_path              = var.nas_kubernetes_access_point
  efs_gid               = "0"
  efs_uid               = "0"
  efs_permissions       = "0755"
  efs_access_point_name = join("-", ["${var.vpc_name}", "${var.system_type}", "k8s", "efs"])
  vpc_name              = var.vpc_name
  system_type           = var.system_type
}