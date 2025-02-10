resource "aws_ec2_instance_state" "test" {
  instance_id = var.ec2_instance_id
  state       = var.ec2_instance_state
}