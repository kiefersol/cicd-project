# ACL 모두 허용
locals {
  public_subnet_ingress = [
     ["100", "-1", "0.0.0.0/0", "0", "0", "ALLOW"],   
   ]

   private_subnet_ingress = [
     ["100", "-1", "0.0.0.0/0", "0", "0", "ALLOW"],
   ]

   public_subnet_egress = [
     ["100", "-1", "0.0.0.0/0", "0", "0", "ALLOW"]
   ]

   private_subnet_egress = [
     ["100", "-1", "0.0.0.0/0", "0", "0", "ALLOW"]
   ]
}

resource "aws_network_acl" "sol_acl_public" {
  vpc_id     = aws_vpc.sol_vpc.id
  subnet_ids = [aws_subnet.sol_subnet_public.id]

  dynamic "ingress" {
    for_each = local.public_subnet_ingress
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
    for_each = local.public_subnet_egress
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
    Name = join("-", ["${var.vpc_name}","public","acl"])
  }
}


resource "aws_network_acl" "sol_acl_public" {
  vpc_id     = aws_vpc.sol_vpc.id
  subnet_ids = [aws_subnet.sol_subnet_private.id]

  dynamic "ingress" {
    for_each = local.private_subnet_ingress
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
    for_each = local.private_subnet_egress
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
    Name = join("-", ["${var.vpc_name}","private","acl"])
  }
}
