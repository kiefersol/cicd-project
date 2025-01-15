# elastic ip - nat gateway용
module "sol_nat_eip" {
  source              = "./modules/network_subnet/eip"
  count               = var.nat_install ? length(var.zone) : 0
  eip_name            = join("-", ["${var.vpc_name}", "${var.system_type}", lower("${var.zone[count.index]}"), "nat", "eip"])
  internet_gateway_id = data.aws_internet_gateway.internet_gateway_info.id
}

# nat gateway
module "sol_nat_gateway" {
  source              = "./modules/network_subnet/nat_gw"
  count               = var.nat_install ? length(var.zone) : 0
  nat_gateway_name    = join("-", ["${var.vpc_name}", "${var.system_type}", lower("${var.zone[count.index]}"), "nat"])
  eip_id              = module.sol_nat_eip[count.index].eip_info.id
  subnet_ip           = module.sol_subnet_public[count.index].subnet_info.id
  internet_gateway_id = data.aws_internet_gateway.internet_gateway_info.id
}

# private route table 
# NAT 생성 여부에 상관없이 private subnet에 route table 무조건 생성
module "sol_route_table" {
  source           = "./modules/network_subnet/route_table"
  count            = 1
  vpc_id           = data.aws_vpc.vpc_info.id
  route_table_name = join("-", ["${var.vpc_name}", "${var.system_type}", "pri", "route_table"])
  vpc_name         = var.vpc_name
  system_type      = var.system_type
}

# private route - private 서브넷에서 0.0.0.0으로 향하는 패킷은 NAT로 라우팅
# nat에 대한 route 규칙은 nat 생성 여부에 따라 설치 선택
module "sol_private_route" {
  source           = "./modules/network_subnet/route"
  count            = var.nat_install ? length(var.zone) : 0
  route_table_id   = module.sol_route_table[0].route_table_info.id
  destination_cidr = "0.0.0.0/0"
  nat_gateway_id   = module.sol_nat_gateway[count.index].nat_gateway_info.id
}

# public route table association (default Route Table과 public 서브넷과 연결)
module "sol_public_route_table_associaion" {
  source         = "./modules/network_subnet/route_table_association"
  count          = length(var.zone)
  subnet_id      = module.sol_subnet_public[count.index].subnet_info.id
  route_table_id = data.aws_vpc.vpc_info.main_route_table_id
}

# private route table association
module "sol_private_route_table_associaion" {
  source         = "./modules/network_subnet/route_table_association"
  count          = length(var.zone)
  subnet_id      = module.sol_subnet_private[count.index].subnet_info.id
  route_table_id = module.sol_route_table[0].route_table_info.id
}

