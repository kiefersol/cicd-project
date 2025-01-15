# kubernetes cluster가 위치할 서브넷에 대한 route table 이어서 tag 처리 필요
resource "aws_route_table" "sol_route_table" {
  vpc_id = var.vpc_id
  tags = tomap({
    "Name"                                                     = var.route_table_name,
    "kubernetes.io/cluster/${var.vpc_name}-${var.system_type}" = "owned"
  })
}