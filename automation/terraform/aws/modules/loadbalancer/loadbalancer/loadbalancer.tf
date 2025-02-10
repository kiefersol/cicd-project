resource "aws_lb" "sol_lb" {
  name = var.lb_name
  #  gateway(L3), network(L4), application(L7)
  load_balancer_type = var.lb_type
  # true인 경우 LB는 내부
  internal = var.lb_network_type
  # network 서브넷 유형의 로드 밸런서만 추가
  subnets           = var.subnet_id_list
  security_groups   = var.sg_list
  client_keep_alive = var.lb_client_keep_alive

  # 로드 밸런서 가용성 영역 간에 트래픽이 분산되는 방식
  # any_availability_zone = 특정 AZ에 우선순위를 두지 않고, 가용한 리소스 중 아무거나 선택 (라운드로빈 방식)
  # availability_zone_affinity = 클라이언트 요청이 가능한 한 특정 AZ에 우선적으로 연결되도록 라우팅 (source ip 라우팅)
  # partial_availability_zone_affinity. = 특정 AZ에 대한 친화성을 유지하려고 하지만, AZ가 부분적으로 가용하지 않을 경우에도 유연하게 다른 AZ로 라우팅
  dns_record_client_routing_policy = var.lb_routing_policy

  # 트래픽 균등 분배
  # true - 각 가용 영역에 있는 대상의 수와 상관없이, 모든 대상이 동일한 트래픽을 받습니다.
  # false = 대상이 적은 AZ는 더 적은 트래픽을 받습니다.
  enable_cross_zone_load_balancing = false
  tags = {
    Name                                                       = var.lb_name,
    "kubernetes.io/cluster/${var.vpc_name}/${var.system_type}" = "owned"
  }
}


