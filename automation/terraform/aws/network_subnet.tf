# # public route table association
# module "sol_public_route_table_associaion" {
#   source = "./modules/network_subnet/route_table_association"
#   count = length(var.zone)
#   subnet_id = module.sol_subnet_public[count.index].subnet_info.id
#   route_table_id = data.aws_vpc.selected.main_route_table_id
# }

# # private route table
# module "sol_route_table" {
#   source = "./modules/network_subnet/route_table"
#   count = length(var.zone)
#   vpc_id = data.aws_vpc.selected.id
#   route_table_name = join("-", ["${var.vpc_name}","${var.system_type}", lower("${var.zone[count.index]}"), "route_table"])
#   system_type = var.system_type
#   vpc_name = var.vpc_name
# }

# # private route table association
# module "sol_private_route_table_associaion" {
#   source = "./modules/network_subnet/route_table_association"
#   count = length(var.zone)
#   subnet_id = module.sol_subnet_private[count.index].subnet_info.id
#   route_table_id = module.sol_route_table[count.index].route_table_info.id
# }

# # private route - target to nat gateway
# module "sol_private_route" {
#   source = "./modules/network_subnet/route"
#   count = length(var.zone)
#   route_table_id = module.sol_route_table[count.index].route_table_info.id
#   destination_cidr = "0.0.0.0/0"
#   nat_gateway_id = module.sol_nat_gateway[count.index].nat_gateway_info.id
# }