resource "aws_lb_target_group_attachment" "sol_target_group_attachment" {
  target_group_arn = var.target_group_arn
  target_id        = var.target_instance_id
}