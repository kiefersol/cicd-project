# kubernetes loadbalancer
module "sol_lb_k8s" {
  source               = "./modules/loadbalancer/loadbalancer"
  count                = var.k8s_manual_install ? 1 : 0
  lb_name              = join("-", ["${var.vpc_name}", "${var.system_type}", "k8s-lb"])
  lb_type              = "network" # l4 레벨
  lb_network_type      = false     # 내부 로드벨런서일 경우 true
  subnet_id_list       = concat([], [for info in module.sol_subnet_public : info.subnet_info.id])
  sg_list              = [module.sol_k8s_lb_sg[0].sg_info.id]
  lb_client_keep_alive = 3600
  lb_routing_policy    = "any_availability_zone"
  vpc_name             = var.vpc_name
  system_type          = var.system_type
}

# target group
module "sol_lb_k8s_target_group" {
  source                                   = "./modules/loadbalancer/target_group"
  count                                    = var.k8s_manual_install ? length(var.lb_k8s_component_list) : 0
  vpc_id                                   = data.aws_vpc.vpc_info.id
  target_group_name                        = join("-", ["${var.vpc_name}", "${var.system_type}", "k8s-tg", lower("${var.lb_k8s_component_list[count.index]}")])
  target_group_protocol                    = "TCP"
  target_group_port                        = var.lb_k8s_target_group_port[count.index]
  target_group_health_check_protocol       = "TCP"
  target_group_cross_zone_enabled          = false
  target_group_health_check_port           = var.lb_k8s_target_group_health_check_port[count.index]
  target_group_health_check_cycle          = var.lb_k8s_target_group_health_check_cycle
  target_group_health_check_up_threshold   = var.lb_k8s_target_group_health_check_up_threshold
  target_group_health_check_down_threshold = var.lb_k8s_target_group_health_check_down_threshold
}

#target group attachment
module "sol_lb_k8s_target_group_attachment_master1" {
  source             = "./modules/loadbalancer/target_group_attachment"
  count              = var.master_count == 1 ? length(var.lb_k8s_component_list) : 0
  target_group_arn   = module.sol_lb_k8s_target_group[count.index].lb_target_group_info.arn
  target_instance_id = module.sol_master_node[0].ec2_info.id
}

module "sol_lb_k8s_target_group_attachment_master2" {
  source             = "./modules/loadbalancer/target_group_attachment"
  count              = var.master_count == 2 ? length(var.lb_k8s_component_list) : 0
  target_group_arn   = module.sol_lb_k8s_target_group[count.index].lb_target_group_info.arn
  target_instance_id = module.sol_master_node[1].ec2_info.id
}

module "sol_lb_k8s_target_group_attachment_master3" {
  source             = "./modules/loadbalancer/target_group_attachment"
  count              = var.master_count == 3 ? length(var.lb_k8s_component_list) : 0
  target_group_arn   = module.sol_lb_k8s_target_group[count.index].lb_target_group_info.arn
  target_instance_id = module.sol_master_node[2].ec2_info.id
}

module "sol_lb_k8s_target_group_attachment_worker1" {
  source             = "./modules/loadbalancer/target_group_attachment"
  count              = (var.k8s_nodeport && var.worker_count == 1) ? length(var.lb_k8s_component_list) : 0
  target_group_arn   = module.sol_lb_k8s_target_group[count.index].lb_target_group_info.arn
  target_instance_id = module.sol_worker_node[0].ec2_info.id
}

module "sol_lb_k8s_target_group_attachment_worker2" {
  source             = "./modules/loadbalancer/target_group_attachment"
  count              = (var.k8s_nodeport && var.worker_count == 2) ? length(var.lb_k8s_component_list) : 0
  target_group_arn   = module.sol_lb_k8s_target_group[count.index].lb_target_group_info.arn
  target_instance_id = module.sol_worker_node[1].ec2_info.id
}

module "sol_lb_k8s_target_group_attachment_worker3" {
  source             = "./modules/loadbalancer/target_group_attachment"
  count              = (var.k8s_nodeport && var.worker_count == 3) ? length(var.lb_k8s_component_list) : 0
  target_group_arn   = module.sol_lb_k8s_target_group[count.index].lb_target_group_info.arn
  target_instance_id = module.sol_worker_node[2].ec2_info.id
}

# loadbalancer listener
module "sol_lb_k8s_listener" {
  source            = "./modules/loadbalancer/listener"
  count             = var.k8s_manual_install ? length(var.lb_k8s_component_list) : 0
  lb_arn            = module.sol_lb_k8s[0].lb_info.arn
  listener_port     = var.lb_k8s_listener_port[count.index]
  listener_protocol = var.lb_k8s_listener_protocol
  tcp_idle_timeout  = 360
  target_group_arn  = module.sol_lb_k8s_target_group[count.index].lb_target_group_info.arn
  listener_type     = "forward"
}





