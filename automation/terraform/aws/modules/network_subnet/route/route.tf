resource "aws_route" "sol_route" {
  route_table_id = var.route_table_id

  # 0.0.0.0/0 로 향하는 패킷은 NAT 게이트웨이로 전달
  destination_cidr_block = var.destination_cidr

  # public은 gateway_id, private는 nat_gateway_id
  nat_gateway_id = var.nat_gateway_id
}
