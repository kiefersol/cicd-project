resource "aws_network_acl" "sol_acl" {
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  dynamic "ingress" {
    for_each = var.ingress_list
    content {
      rule_no    = tonumber(ingress.value[0])
      protocol   = ingress.value[1]
      cidr_block = ingress.value[2]
      from_port  = ingress.value[3]
      to_port    = ingress.value[4]
      action     = ingress.value[5]
    }
  }

  dynamic "egress" {
    for_each = var.egress_list
    content {
      rule_no    = tonumber(egress.value[0])
      protocol   = egress.value[1]
      cidr_block = egress.value[2]
      from_port  = egress.value[3]
      to_port    = egress.value[4]
      action     = egress.value[5]
    }
  }

  tags = {
    Name = var.acl_name
  }
}