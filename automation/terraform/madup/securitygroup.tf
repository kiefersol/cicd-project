resource "aws_security_group" "nodegroup_sg" {
  name        = join("-", ["${var.vpc_name}", "nodegroup", "sg"])
  description = "Security Group For Node Group"
  vpc_id      = aws_vpc.vpc.id

  # 나가는 것 모두 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = tomap({
    "Name" = join("-", ["${var.vpc_name}", "nodegroup", "sg"]),
    "kubernetes.io/cluster/${var.vpc_name}" = "shared"
  })
}

resource "aws_security_group" "alb_sg" {
  name        = join("-", ["${var.vpc_name}", "alb", "sg"])
  description = "Allow 123.123.123.123 to access ALB"
  vpc_id      = aws_vpc.vpc.id

  # 특정 IP에서만 접근 허용
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.nginx_allow_ip 
  }

  # 나가는 것 모두 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ALB → NodeGroup 보안 그룹으로 인바운드 허용 (port 80)
resource "aws_security_group_rule" "alb_to_nodegroup" {
  type                     = "ingress"
  from_port               = 0
  to_port                 = 0
  protocol                = "-1"
  security_group_id        = aws_security_group.nodegroup_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
  description              = "Allow ALB to access NodeGroup"
}

