#VPC
module "sol_vpc" {
  count       = var.vpc_install ? 1 : 0
  source   = "./modules/vpc"
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
}
