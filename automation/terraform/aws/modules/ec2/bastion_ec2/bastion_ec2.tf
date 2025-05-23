resource "aws_instance" "sol_ec2" {
  ami           = var.ec2_image_code
  instance_type = var.ec2_product_code
  key_name      = var.loginkey
  user_data = base64encode(templatefile(var.init_script, {
  }))
  network_interface {
    network_interface_id = var.nic_id
    device_index         = var.nic_order
  }
  root_block_device {
    volume_size = var.root_block_device_size
  }
  tags = tomap({
    "Name" = var.ec2_name
  })
}
