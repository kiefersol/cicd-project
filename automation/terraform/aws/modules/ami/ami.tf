resource "aws_ami_from_instance" "sol_k8s_ami" {
  name               = var.ami_name
  source_instance_id = var.for_ami_instance_id
}