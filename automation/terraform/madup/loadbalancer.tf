resource "aws_lb" "nginx_lb" {
  name = join("-", ["${var.vpc_name}", "nginx-lb"])
  load_balancer_type = "application"
  internal = false   # 외부에서 접근 가능
  subnets           = aws_subnet.subnet[*].id
  security_groups   = [aws_security_group.alb_sg.id]
  tags = {
    Name = join("-", ["${var.vpc_name}", "nginx-lb"]),
    "kubernetes.io/cluster/${var.vpc_name}" = "shared"
  }
}

resource "aws_lb_target_group" "nginx_target_group" {
  vpc_id   = aws_vpc.vpc.id
  name     = join("-", ["${var.vpc_name}", "nginx-tg"])
  protocol = "HTTP"
  port     = var.nginx_target_group_port

  # 부하분산을 하는 각 서버의 서비스를 주기적으로 헬스체크해 정상적인 서비스 쪽으로만 부하를 분산
  health_check {
    protocol            = "HTTP"
    port                = var.nginx_target_group_health_check_port
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = {
    Name = join("-", ["${var.vpc_name}", "nginx-tg"])
  }
}

resource "aws_lb_listener" "nginx_listener" {
  load_balancer_arn = aws_lb.nginx_lb.arn
  port              = var.nginx_listener_port
  protocol          = "HTTP"

  # Host 기반 라우팅 설정
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.nginx_target_group.arn
  }
}

# nginx.example.com으로 들어온 HTTP 요청을 aws_lb_target_group.nginx_target_group으로 포워딩
resource "aws_lb_listener_rule" "nginx_listener_rule" {
  listener_arn = aws_lb_listener.nginx_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_target_group.arn
  }
  # host_header는 Host 헤더가 "nginx.example.com"일 때만 이 규칙이 적용
  condition {
    host_header {
      values = ["nginx.example.com"]
    }
  }
}

# eks와 연결된 노드그룹을 가져오기
data "aws_instances" "eks_nodes" {
  filter {
    name   = "tag:eks:nodegroup-name"
    values = [join("-", ["${var.vpc_name}","nodegroup"])]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

# lb와 노드그룹 연결
resource "aws_lb_target_group_attachment" "nginx_nodeport_attachment" {
  count = length(data.aws_instances.eks_nodes.ids)
  target_group_arn = aws_lb_target_group.nginx_target_group.arn
  target_id        = data.aws_instances.eks_nodes.ids[count.index]  # EKS 노드의 EC2 인스턴스 ID
  port             = var.nginx_target_group_port
}