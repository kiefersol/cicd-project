resource "aws_instance" "sol_ec2" {
  ami           = var.ec2_image_code
  instance_type = var.ec2_product_code
  key_name      = var.loginkey
  user_data = base64encode(templatefile(var.init_script, {
    infra_ip = var.infra_node_ip
  }))
  iam_instance_profile = var.iam_instance_profile
  network_interface {
    network_interface_id = var.nic_id
    device_index         = var.nic_order
  }
  root_block_device {
    volume_size = var.root_block_device_size
  }
  ebs_block_device {
    delete_on_termination = true
    device_name           = "/dev/sdf"
    volume_size           = var.ebs_block_device_size
    volume_type           = "gp2"
  }
  tags = tomap({
    "Name"                                                     = var.ec2_name,
    "kubernetes.io/cluster/${var.vpc_name}/${var.system_type}" = "owned",
    "type"                                                     = "${var.vpc_name}-${var.system_type}"
  })
}