
module "sol_internet_gateway" {
  source                = "./modules/network_vpc/internet_gw"
  count                 = var.vpc_install ? 1 : 0
  vpc_id                = module.sol_vpc[0].vpc_info.id
  internet_gateway_name = join("-", ["${var.vpc_name}", "internet_gw"])
  vpc_info              = module.sol_vpc
}

data "aws_internet_gateway" "internet_gateway_info" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.vpc_info.id]
  }
  depends_on = [
    module.sol_internet_gateway
  ]
}

#default (public) route table - vpc와 연결된 default route table에 이름 넣기
module "sol_default_route_table" {
  source                   = "./modules/network_vpc/default_route_table"
  count                    = var.vpc_install ? 1 : 0
  default_route_table_id   = module.sol_vpc[0].vpc_info.main_route_table_id
  default_route_table_name = join("-", ["${var.vpc_name}", "main_route_table"])
  vpc_info                 = module.sol_vpc
}

# public route - 0.0.0.0 to internet gateway
module "sol_default_route" {
  source                = "./modules/network_vpc/default_route"
  count                 = var.vpc_install ? 1 : 0
  route_table_id        = module.sol_vpc[0].vpc_info.main_route_table_id
  destination_cidr      = "0.0.0.0/0"
  internet_gateway_id   = module.sol_internet_gateway[0].internet_gateway_info.id
  vpc_info              = module.sol_vpc
  internet_gateway_info = module.sol_internet_gateway
}

