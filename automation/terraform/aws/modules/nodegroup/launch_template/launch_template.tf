resource "aws_launch_template" "sol_nodegroup_launch_template" {
  name = var.nodegroup_template_name
  user_data = base64encode(templatefile(
    var.k8s_ng_init_script,
    {
      infra_ip = var.infra_node_ip
    }
  ))
  key_name      = var.login_key_name
  instance_type = var.nodegroup_instance_type
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = var.ng_volume_size
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }
  block_device_mappings {
    device_name = "/dev/sdf"
    ebs {
      volume_size           = var.ng_ebs_volume_size
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }
  network_interfaces {
    security_groups = var.security_groups
  }
  depends_on = [
    var.infra_node_ip
  ]
}