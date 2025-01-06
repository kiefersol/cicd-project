locals {
  k8s_lb_subnet_cidr_ingress = [
    for cidr in var.subnet_public_cidr : ["-1", cidr, "0", "0"]
  ]

  infra_lb_subnet_cidr_ingress = [
    for cidr in var.subnet_public_cidr : ["-1", cidr, "0", "0"]
  ]

  private_subnet_cidr_ingress = [
    for cidr in var.subnet_private_cidr : ["-1", cidr, "0", "0"]
  ]

  public_subnet_cidr_ingress = [
    for cidr in var.subnet_public_cidr : ["-1", cidr, "0", "0"]
  ]

  nat_ip_sg_rules_ingress = [
    for nat_info in module.sol_bxcr_eip : ["-1", join("", [nat_info.eip_info.public_ip, "/32"]), "0", "0"]
  ]

  ansible_ip_rules_ingress = [
    ["-1", "220.118.2.248/32", "0", "0"] #ansible server
  ]

  jumpbox_sg_rules_ingress = [
    ["-1", "220.118.2.248/32", "0", "0"], #hansol.choi
    ["-1", "0.0.0.0/0", "0", "0"]         # anyware - 설치 시 우선 다 열어 놓기 : 나중에 수동으로 삭제
  ]

  default_sg_rules_ingress = [
    # vpc내 모든 범위 허용
    ["-1", var.vpc_cidr, 0, 0],
    ["-1", "0.0.0.0/0", "0", "0"]
  ]

  default_sg_rules_egress = [
    # 모든 범위 허용
    ["-1", "0.0.0.0/0", 0, 0]
  ]
}

# 쿠버네티스 로드밸런서
module "sol_k8s_lb_sg" {
  source       = "./modules/sg"
  count        = var.master_count > 1 ? 1 : 0
  sg_name      = join("-", ["${var.vpc_name}", "k8s-lb", "sg"])
  description  = "Security Group For k8s lb"
  vpc_id       = module.sol_vpc.vpc_info.id
  ingress_list = concat(local.jumpbox_sg_rules_ingress, local.nat_ip_sg_rules_ingress, local.ansible_ip_rules_ingress)
  egress_list  = local.default_sg_rules_egress
  vpc_name     = var.vpc_name
}

module "sol_infra_lb_sg" {
  source       = "./modules/sg"
  count        = var.infra_count > 1 ? 1 : 0
  sg_name      = join("-", ["${var.vpc_name}", "infra-lb", "sg"])
  description  = "Security Group For infra lb"
  vpc_id       = module.sol_vpc.vpc_info.id
  ingress_list = concat(local.jumpbox_sg_rules_ingress, local.nat_ip_sg_rules_ingress, local.ansible_ip_rules_ingress)
  egress_list  = local.default_sg_rules_egress
  vpc_name     = var.vpc_name
}

module "sol_nas_sg" {
  source       = "./modules/sg"
  sg_name      = join("-", ["${var.vpc_name}", "nas", "sg"])
  description  = "Security Group for NAS"
  vpc_id       = module.sol_vpc.vpc_info.id
  ingress_list = local.private_subnet_cidr_ingress
  egress_list  = local.default_sg_rules_egress
  vpc_name     = var.vpc_name
}

module "sol_jumpbox_sg" {
  source       = "./modules/sg"
  sg_name      = join("-", ["${var.vpc_name}", "jumpbox", "sg"])
  description  = "Security Group For Jumpbox"
  vpc_id       = module.sol_vpc.vpc_info.id
  ingress_list = concat(local.jumpbox_sg_rules_ingress, local.nat_ip_sg_rules_ingress, local.ansible_ip_rules_ingress)
  egress_list  = local.default_sg_rules_egress
  vpc_name     = var.vpc_name
}

module "sol_infra_sg" {
  source       = "./modules/sg"
  count        = var.infra_count > 1 ? 1 : 0
  sg_name      = join("-", ["${var.vpc_name}", "infra", "sg"])
  description  = "Security Group For Infra Node"
  vpc_id       = module.sol_vpc.vpc_info.id
  ingress_list = concat(local.infra_lb_subnet_cidr_ingress, local.private_subnet_cidr_ingress, local.public_subnet_cidr_ingress, local.nat_ip_sg_rules_ingress, local.jumpbox_sg_rules_ingress, local.ansible_ip_rules_ingress)
  egress_list  = local.default_sg_rules_egress
  vpc_name     = var.vpc_name
}

module "sol_master_sg" {
  source       = "./modules/sg"
  count        = var.master_count > 1 ? 1 : 0
  sg_name      = join("-", ["${var.vpc_name}", "master", "sg"])
  description  = "Security Group For Master Node"
  vpc_id       = module.sol_vpc.vpc_info.id
  ingress_list = concat(local.k8s_lb_subnet_cidr_ingress, local.private_subnet_cidr_ingress, local.public_subnet_cidr_ingress, local.nat_ip_sg_rules_ingress, local.ansible_ip_rules_ingress, local.jumpbox_sg_rules_ingress)
  egress_list  = local.default_sg_rules_egress
  vpc_name     = var.vpc_name
}

module "sol_worker_sg" {
  source       = "./modules/sg"
  count        = var.worker_count > 1 ? 1 : 0
  sg_name      = join("-", ["${var.vpc_name}", "worker", "sg"])
  description  = "Security Group For Worker Node"
  vpc_id       = module.sol_vpc.vpc_info.id
  ingress_list = concat(local.k8s_lb_subnet_cidr_ingress, local.private_subnet_cidr_ingress, local.public_subnet_cidr_ingress, local.nat_ip_sg_rules_ingress, local.jumpbox_sg_rules_ingress, local.ansible_ip_rules_ingress)
  egress_list  = local.default_sg_rules_egress
  vpc_name     = var.vpc_name
}

# module "sol_default_sg" {
#    source               = "./modules/sg"
#    sg_name             = join("-", ["${var.vpc_name}","default","sg"])
#    description             = "Security Group for default"
#    vpc_id               = module.sol_vpc.vpc_info.id
#    ingress_list         = local.default_sg_rules_ingress
#    egress_list          = local.default_sg_rules_egress
#    vpc_name             = var.vpc_name
# }
