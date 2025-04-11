resource "aws_launch_template" "sol_asg_launch_template" {
  name = var.asg_template_name
  user_data = base64encode(templatefile(var.asg_init_script,
    {
      master_ip = var.master_node_ip,
      k8s_lb    = var.k8s_lb
    }
  ))
  key_name               = var.asg_login_key_name
  image_id               = var.asg_image_code
  instance_type          = var.asg_product_code
  vpc_security_group_ids = var.asg_security_groups
  iam_instance_profile {
    name = var.asg_iam_instance_profile_name
  }
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = var.asg_volume_size
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }
  # block_device_mappings {
  #   device_name = "/dev/sdf"
  #   ebs {
  #     volume_size           = var.asg_ebs_volume_size
  #     volume_type           = "gp2"
  #     delete_on_termination = true
  #   }
  # }
  depends_on = [
    var.master_node_ip,
    var.k8s_lb
  ]
}