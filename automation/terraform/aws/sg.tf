locals {
  lb_subnet_cidr_ingress = [
    for cidr in var.subnet_lb_cidr : ["-1", cidr, "0", "0"]
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
    # 모든 범위 허용
    ["-1", var.vpc_cidr, 0, 0]
  ]

  default_sg_rules_egress = [
    # 모든 범위 허용
    ["-1", "0.0.0.0/0", 0, 0]
  ]
}

module "sol_k8s_lb_sg" {
  source       = "./modules/sg"
  count        = var.k8s_manual_install ? 1 : 0
  sg_name     = join("-", ["${var.vpc_name}", "${var.system_type}", "k8s-lb", "sg"])
  sg_desc     = "Security Group For k8s lb"
  vpc_id       = data.aws_vpc.selected.id
  ingress_list = concat(local.jumpbox_sg_rules_ingress, local.nat_ip_sg_rules_ingress, local.ansible_ip_rules_ingress)
  egress_list  = local.default_sg_rules_egress
  vpc_name     = var.vpc_name
  system_type  = var.system_type
}

module "sol_infra_lb_sg" {
  source       = "./modules/sg"
  sg_name     = join("-", ["${var.vpc_name}", "${var.system_type}", "infra-lb", "sg"])
  sg_desc     = "Security Group For infra lb"
  vpc_id       = data.aws_vpc.selected.id
  ingress_list = concat(local.jumpbox_sg_rules_ingress, local.nat_ip_sg_rules_ingress, local.ansible_ip_rules_ingress)
  egress_list  = local.default_sg_rules_egress
  vpc_name     = var.vpc_name
  system_type  = var.system_type
}

# module "sol_default_sg" {
#    source               = "./modules/sg"
#    sg_name             = join("-", ["${var.vpc_name}","${var.system_type}","default","sg"])
#    sg_desc             = "Security Group for default"
#    vpc_id               = data.aws_vpc.selected.id
#    ingress_list         = local.default_sg_rules_ingress
#    egress_list          = local.default_sg_rules_egress
#    vpc_name             = var.vpc_name
#    system_type          = var.system_type
# }

module "sol_nas_sg" {
  source       = "./modules/sg"
  sg_name     = join("-", ["${var.vpc_name}", "${var.system_type}", "nas", "sg"])
  sg_desc     = "Security Group for NAS"
  vpc_id       = data.aws_vpc.selected.id
  ingress_list = local.private_subnet_cidr_ingress
  egress_list  = local.default_sg_rules_egress
  vpc_name     = var.vpc_name
  system_type  = var.system_type
}

module "sol_jumpbox_sg" {
  source       = "./modules/sg"
  sg_name     = join("-", ["${var.vpc_name}", "${var.system_type}", "jumpbox", "sg"])
  sg_desc     = "Security Group For Jumpbox"
  vpc_id       = data.aws_vpc.selected.id
  ingress_list = concat(local.jumpbox_sg_rules_ingress, local.nat_ip_sg_rules_ingress, local.ansible_ip_rules_ingress)
  egress_list  = local.default_sg_rules_egress
  vpc_name     = var.vpc_name
  system_type  = var.system_type
}

module "sol_infra_sg" {
  source       = "./modules/sg"
  sg_name     = join("-", ["${var.vpc_name}", "${var.system_type}", "infra", "sg"])
  sg_desc     = "Security Group For Infra Node"
  vpc_id       = data.aws_vpc.selected.id
  ingress_list = concat(local.private_subnet_cidr_ingress, local.public_subnet_cidr_ingress, local.nat_ip_sg_rules_ingress, local.jumpbox_sg_rules_ingress, local.ansible_ip_rules_ingress)
  egress_list  = local.default_sg_rules_egress
  vpc_name     = var.vpc_name
  system_type  = var.system_type
}

module "sol_master_sg" {
  source       = "./modules/sg"
  count        = var.k8s_manual_install ? 1 : 0
  sg_name     = join("-", ["${var.vpc_name}", "${var.system_type}", "master", "sg"])
  sg_desc     = "Security Group For Master Node"
  vpc_id       = data.aws_vpc.selected.id
  ingress_list = concat(local.private_subnet_cidr_ingress, local.public_subnet_cidr_ingress, local.nat_ip_sg_rules_ingress, local.ansible_ip_rules_ingress, local.jumpbox_sg_rules_ingress)
  egress_list  = local.default_sg_rules_egress
  vpc_name     = var.vpc_name
  system_type  = var.system_type
}

module "sol_asg_sg" {
  source       = "./modules/sg"
  sg_name     = join("-", ["${var.vpc_name}", "${var.system_type}", "worker", "sg"])
  sg_desc     = "Security Group For Auto Scaling Group"
  count        = var.k8s_manual_worker_asg_install ? 1 : 0
  vpc_id       = data.aws_vpc.selected.id
  ingress_list = concat(local.lb_subnet_cidr_ingress, local.private_subnet_cidr_ingress, local.public_subnet_cidr_ingress, local.nat_ip_sg_rules_ingress, local.jumpbox_sg_rules_ingress, local.ansible_ip_rules_ingress)
  egress_list  = local.default_sg_rules_egress
  vpc_name     = var.vpc_name
  system_type  = var.system_type
}

module "sol_asg_sg_upgrade" {
  source       = "./modules/sg"
  sg_name     = join("-", ["${var.vpc_name}", "${var.system_type}", "worker", "sg"])
  sg_desc     = "Security Group For Auto Scaling Group"
  count        = var.k8s_upgrade ? 1 : 0
  vpc_id       = data.aws_vpc.selected.id
  ingress_list = concat(local.lb_subnet_cidr_ingress, local.private_subnet_cidr_ingress, local.public_subnet_cidr_ingress, local.nat_ip_sg_rules_ingress, local.jumpbox_sg_rules_ingress, local.ansible_ip_rules_ingress)
  egress_list  = local.default_sg_rules_egress
  vpc_name     = var.vpc_name
  system_type  = var.system_type
}




