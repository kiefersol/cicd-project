# infra loadbalancer
module "sol_lb_infra" {
  source               = "./modules/loadbalancer/loadbalancer"
  count                = var.infra_count > 0 ? 1 : 0
  lb_name              = join("-", ["${var.vpc_name}", "${var.system_type}", "infra-lb"])
  lb_type              = "network" # l4 레벨
  lb_network_type      = false     # 내부 로드벨런서일 경우 true
  subnet_id_list       = concat([], [for info in module.sol_subnet_private : info.subnet_info.id])
  sg_list              = [module.sol_infra_lb_sg[0].sg_info.id]
  lb_client_keep_alive = 3600
  lb_routing_policy    = "any_availability_zone"
  vpc_name             = var.vpc_name
  system_type          = var.system_type
}

# target group
module "sol_lb_infra_target_group" {
  source                                   = "./modules/loadbalancer/target_group"
  count                                    = var.infra_count > 0 ? length(var.lb_infra_component_list) : 0
  vpc_id                                   = data.aws_vpc.vpc_info.id
  target_group_name                        = join("-", ["${var.vpc_name}", "${var.system_type}", "infra-tg", lower("${var.lb_infra_component_list[count.index]}")])
  target_group_protocol                    = "TCP"
  target_group_port                        = var.lb_infra_target_group_port[count.index]
  target_group_health_check_protocol       = "TCP"
  target_group_cross_zone_enabled          = false
  target_group_health_check_port           = var.lb_infra_target_group_health_check_port[count.index]
  target_group_health_check_cycle          = var.lb_infra_target_group_health_check_cycle
  target_group_health_check_up_threshold   = var.lb_infra_target_group_health_check_up_threshold
  target_group_health_check_down_threshold = var.lb_infra_target_group_health_check_down_threshold
}

#target group attachment
module "sol_lb_infra_target_group_attachment_infra1" {
  source             = "./modules/loadbalancer/target_group_attachment"
  count              = length(var.lb_infra_component_list)
  target_group_arn   = module.sol_lb_infra_target_group[count.index].lb_target_group_info.arn
  target_instance_id = module.sol_infra_node[0].ec2_info.id
}

module "sol_lb_infra_target_group_attachment_infra2" {
  source             = "./modules/loadbalancer/target_group_attachment"
  count              = var.infra_count == 2 ? length(var.lb_infra_component_list) : 0
  target_group_arn   = module.sol_lb_infra_target_group[count.index].lb_target_group_info.arn
  target_instance_id = module.sol_infra_node[1].ec2_info.id
}

# loadbalancer listener
module "sol_lb_listener" {
  source            = "./modules/loadbalancer/listener"
  count             = length(var.lb_infra_component_list)
  lb_arn            = module.sol_lb_infra[0].lb_info.arn
  listener_port     = var.lb_infra_listener_port[count.index]
  listener_protocol = var.lb_infra_listener_protocol
  tcp_idle_timeout  = 360
  target_group_arn  = module.sol_lb_infra_target_group[count.index].lb_target_group_info.arn
  listener_type     = "forward"
}




