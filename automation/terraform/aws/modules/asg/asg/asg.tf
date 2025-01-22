resource "aws_autoscaling_group" "sol_asg" {
  name                = var.asg_name
  vpc_zone_identifier = var.asg_subnet_ids
  max_size            = var.asg_max_size
  min_size            = var.asg_min_size
  desired_capacity    = var.asg_desired_capacity
  target_group_arns   = var.target_group_list
  launch_template {
    id      = var.asg_template_id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.asg_name
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.vpc_name}-${var.system_type}"
    value               = "owned"
    propagate_at_launch = true
  }
}