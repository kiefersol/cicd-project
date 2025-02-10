resource "aws_lb_target_group" "sol_target_group" {
  vpc_id   = var.vpc_id
  name     = var.target_group_name
  protocol = var.target_group_protocol
  port     = var.target_group_port

  # load_balancing_cross_zone_enabled - AWS 로드 밸런서가 여러 AZ에 걸쳐 트래픽을 어떻게 분배할지 결정
  # true - AZ1에 있는 인스턴스와 AZ2에 있는 인스턴스에게 균등하게 요청을 분배합니다.
  # false - AZ1에서 발생하는 트래픽은 AZ1에 있는 EC2 인스턴스들로만 보내지고, AZ2에서 발생하는 트래픽은 AZ2에 있는 EC2 인스턴스들로만 보내진다.
  load_balancing_cross_zone_enabled = var.target_group_cross_zone_enabled

  # 부하분산을 하는 각 서버의 서비스를 주기적으로 헬스체크해 정상적인 서비스 쪽으로만 부하를 분산
  health_check {
    protocol            = var.target_group_health_check_protocol
    port                = var.target_group_health_check_port
    interval            = var.target_group_health_check_cycle
    healthy_threshold   = var.target_group_health_check_up_threshold
    unhealthy_threshold = var.target_group_health_check_down_threshold
  }
  tags = {
    Name = var.target_group_name
  }
}




