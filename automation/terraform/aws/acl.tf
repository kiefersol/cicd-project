# ACL 모두 허용
locals {
  public_subnet_ingress = [
    ["100", "-1", "0.0.0.0/0", "0", "0", "ALLOW"],
  ]

  private_subnet_ingress = [
    ["100", "-1", "0.0.0.0/0", "0", "0", "ALLOW"],
  ]

  public_subnet_egress = [
    ["100", "-1", "0.0.0.0/0", "0", "0", "ALLOW"]
  ]

  private_subnet_egress = [
    ["100", "-1", "0.0.0.0/0", "0", "0", "ALLOW"]
  ]
}

module "sol_public_acl" {
  source       = "./modules/acl"
  count        = 1
  acl_name     = join("-", ["${var.vpc_name}", "${var.system_type}", "public", count.index, "acl"])
  vpc_id       = data.aws_vpc.vpc_info.id
  subnet_ids   = [module.sol_subnet_public[count.index].subnet_info.id]
  ingress_list = local.public_subnet_ingress
  egress_list  = local.public_subnet_egress
}

module "sol_private_acl" {
  source       = "./modules/acl"
  count        = length(var.zone)
  acl_name     = join("-", ["${var.vpc_name}", "${var.system_type}", "private", count.index, "acl"])
  vpc_id       = data.aws_vpc.vpc_info.id
  subnet_ids   = [module.sol_subnet_private[count.index].subnet_info.id]
  ingress_list = local.private_subnet_ingress
  egress_list  = local.private_subnet_egress
}

