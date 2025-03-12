locals {
  # kubernetes LB subnet cidr
  k8s_lb_subnet_cidr_ingress = [
    for cidr in var.subnet_public_cidr : ["-1", cidr, "0", "0"]
  ]

  # infra LB subnet cidr
  infra_lb_subnet_cidr_ingress = [
    for cidr in var.subnet_public_cidr : ["-1", cidr, "0", "0"]
  ]

  # public subnet cidr
  public_subnet_cidr_ingress = [
    for cidr in var.subnet_public_cidr : ["-1", cidr, "0", "0"]
  ]

  # private subnet cidr
  private_subnet_cidr_ingress = [
    for cidr in var.subnet_private_cidr : ["-1", cidr, "0", "0"]
  ]

  # nat ip 허용 
  # length(try(module.sol_nat_eip, [])) > 0 => module.sol_nat_eip가 정상적으로 생성되면 length는 0보다 큰 값이 된다.
  # sol_nat_eip 모듈이 정상적으로 만들어지면 ip 등록, 아니면 빈 리스트 등록
  nat_ip_sg_rules_ingress = length(try(module.sol_nat_eip, [])) > 0 ? [
    for nat_info in module.sol_nat_eip : ["-1", join("", [nat_info.eip_info.public_ip, "/32"]), "0", "0"]
  ] : []

  ansible_ip_rules_ingress = [
    ["-1", "220.118.2.248/32", "0", "0"], #ansible server
    ["-1", "0.0.0.0/0", "0", "0"]
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
  count        = var.k8s_manual_install ? 1 : 0
  sg_name      = join("-", ["${var.vpc_name}", "${var.system_type}", "k8s-lb", "sg"])
  description  = "Security Group For k8s lb"
  vpc_id       = data.aws_vpc.vpc_info.id
  ingress_list = concat(local.private_subnet_cidr_ingress, local.ansible_ip_rules_ingress)
  egress_list  = local.default_sg_rules_egress
  vpc_name     = var.vpc_name
  system_type  = var.system_type
}

module "sol_infra_lb_sg" {
  source       = "./modules/sg"
  count        = var.infra_count > 0 ? 1 : 0
  sg_name      = join("-", ["${var.vpc_name}", "${var.system_type}", "infra-lb", "sg"])
  description  = "Security Group For infra lb"
  vpc_id       = data.aws_vpc.vpc_info.id
  ingress_list = concat(local.private_subnet_cidr_ingress, local.ansible_ip_rules_ingress)
  egress_list  = local.default_sg_rules_egress
  vpc_name     = var.vpc_name
  system_type  = var.system_type
}

module "sol_nas_sg" {
  source       = "./modules/sg"
  count        = var.nas_install ? 1 : 0
  sg_name      = join("-", ["${var.vpc_name}", "${var.system_type}", "nas", "sg"])
  description  = "Security Group for NAS"
  vpc_id       = data.aws_vpc.vpc_info.id
  ingress_list = local.private_subnet_cidr_ingress
  egress_list  = local.default_sg_rules_egress
  vpc_name     = var.vpc_name
  system_type  = var.system_type
}

module "sol_jumpbox_sg" {
  source       = "./modules/sg"
  sg_name      = join("-", ["${var.vpc_name}", "${var.system_type}", "jumpbox", "sg"])
  description  = "Security Group For Jumpbox"
  vpc_id       = data.aws_vpc.vpc_info.id
  ingress_list = concat(local.jumpbox_sg_rules_ingress, local.private_subnet_cidr_ingress, local.ansible_ip_rules_ingress)
  egress_list  = local.default_sg_rules_egress
  vpc_name     = var.vpc_name
  system_type  = var.system_type
}

module "sol_infra_sg" {
  source       = "./modules/sg"
  count        = var.infra_count > 0 ? 1 : 0
  sg_name      = join("-", ["${var.vpc_name}", "${var.system_type}", "infra", "sg"])
  description  = "Security Group For Infra Node"
  vpc_id       = data.aws_vpc.vpc_info.id
  ingress_list = concat(local.private_subnet_cidr_ingress, local.nat_ip_sg_rules_ingress, local.jumpbox_sg_rules_ingress, local.ansible_ip_rules_ingress)
  egress_list  = local.default_sg_rules_egress
  vpc_name     = var.vpc_name
  system_type  = var.system_type
}

module "sol_master_sg" {
  source       = "./modules/sg"
  count        = var.k8s_manual_install ? 1 : 0
  sg_name      = join("-", ["${var.vpc_name}", "${var.system_type}", "master", "sg"])
  description  = "Security Group For Master Node"
  vpc_id       = data.aws_vpc.vpc_info.id
  ingress_list = concat(local.private_subnet_cidr_ingress, local.nat_ip_sg_rules_ingress, local.ansible_ip_rules_ingress, local.jumpbox_sg_rules_ingress)
  egress_list  = local.default_sg_rules_egress
  vpc_name     = var.vpc_name
  system_type  = var.system_type
}

module "sol_worker_ec2_sg" {
  source       = "./modules/sg"
  count        = var.worker_count > 0 ? 1 : 0
  sg_name      = join("-", ["${var.vpc_name}", "${var.system_type}", "worker", "ec2", "sg"])
  description  = "Security Group For Worker Node"
  vpc_id       = data.aws_vpc.vpc_info.id
  ingress_list = concat(local.private_subnet_cidr_ingress, local.nat_ip_sg_rules_ingress, local.jumpbox_sg_rules_ingress, local.ansible_ip_rules_ingress)
  egress_list  = local.default_sg_rules_egress
  vpc_name     = var.vpc_name
  system_type  = var.system_type
}

module "sol_worker_asg_sg" {
  source       = "./modules/sg"
  count        = var.k8s_manual_worker_asg_install ? 1 : 0
  sg_name      = join("-", ["${var.vpc_name}", "${var.system_type}", "worker", "ec2", "sg"])
  description  = "Security Group for worker autoscaling group"
  vpc_id       = data.aws_vpc.vpc_info.id
  ingress_list = concat(local.k8s_lb_subnet_cidr_ingress, local.private_subnet_cidr_ingress, local.nat_ip_sg_rules_ingress, local.jumpbox_sg_rules_ingress, local.ansible_ip_rules_ingress)
  egress_list  = local.default_sg_rules_egress
  vpc_name     = var.vpc_name
  system_type  = var.system_type
}

module "sol_eks_sg" {
  source       = "./modules/sg"
  count        = var.k8s_eks_install ? 1 : 0
  sg_name      = join("-", ["${var.vpc_name}", "${var.system_type}", "eks", "sg"])
  description  = "Security Group For EKS"
  vpc_id       = data.aws_vpc.vpc_info.id
  ingress_list = concat(local.private_subnet_cidr_ingress, local.nat_ip_sg_rules_ingress, local.ansible_ip_rules_ingress, local.jumpbox_sg_rules_ingress)
  egress_list  = local.default_sg_rules_egress
  vpc_name     = var.vpc_name
  system_type  = var.system_type
}

module "sol_nodegroup_sg" {
  source       = "./modules/sg"
  count        = var.k8s_eks_install ? 1 : 0
  sg_name      = join("-", ["${var.vpc_name}", "${var.system_type}", "nodegroup", "sg"])
  description  = "Security Group For Node Group"
  vpc_id       = data.aws_vpc.vpc_info.id
  ingress_list = concat(local.private_subnet_cidr_ingress, local.nat_ip_sg_rules_ingress, local.ansible_ip_rules_ingress, local.jumpbox_sg_rules_ingress)
  egress_list  = local.default_sg_rules_egress
  vpc_name     = var.vpc_name
  system_type  = var.system_type
}