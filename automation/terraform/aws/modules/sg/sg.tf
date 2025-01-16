resource "aws_security_group" "sol_sg" {
  name        = var.sg_name
  description = var.description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_list
    content {
      protocol    = ingress.value[0]
      cidr_blocks = [ingress.value[1]]
      from_port   = ingress.value[2]
      to_port     = ingress.value[3]
    }
  }

  dynamic "egress" {
    for_each = var.egress_list
    content {
      protocol    = egress.value[0]
      cidr_blocks = [egress.value[1]]
      from_port   = egress.value[2]
      to_port     = egress.value[3]
    }

  }
  tags = tomap({
    "Name"                                                     = var.sg_name,
    "kubernetes.io/cluster/${var.vpc_name}/${var.system_type}" = "owned"
  })
}
  