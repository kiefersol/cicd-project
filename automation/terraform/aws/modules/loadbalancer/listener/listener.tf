resource "aws_lb_listener" "sol_lb_listener" {
  load_balancer_arn        = var.lb_arn
  port                     = var.listener_port
  protocol                 = var.listener_protocol
  tcp_idle_timeout_seconds = var.tcp_idle_timeout
  default_action {
    target_group_arn = var.target_group_arn
    type             = var.listener_type
  }
}
