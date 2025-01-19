# elastic ip association
resource "aws_eip_association" "tf_bxcr_eip_association" {
  instance_id   = var.instance_id
  allocation_id = var.allocation_id
}