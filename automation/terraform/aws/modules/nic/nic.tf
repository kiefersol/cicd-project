# Network Interface Card
resource "aws_network_interface" "sol_nic" {
  description     = var.description
  subnet_id       = var.subnet_id
  security_groups = var.security_groups
  tags = tomap({
    "Name"                                                     = var.nic_name,
    "kubernetes.io/cluster/${var.vpc_name}/${var.system_type}" = "owned"
  })
}