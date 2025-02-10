# elastic ip - jumpbox용
module "sol_eip_for_ec2" {
  source              = "./modules/network_ec2/eip"
  count               = length(var.zone)
  eip_name            = join("-", ["${var.vpc_name}", "${var.system_type}", lower("${var.zone[count.index]}"), "ec2", "eip"])
  internet_gateway_id = data.aws_internet_gateway.internet_gateway_info.id
}

module "sol_eip_association_for_ec2" {
  source        = "./modules/network_ec2/eip_association"
  count         = length(var.zone)
  instance_id   = module.sol_bastion_node[count.index].ec2_info.id
  allocation_id = module.sol_eip_for_ec2[count.index].eip_info.id
}