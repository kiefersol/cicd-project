output "asg_launch_template_info" {
  value       = aws_launch_template.sol_asg_launch_template
  description = "auto scaling group launch template info"
}