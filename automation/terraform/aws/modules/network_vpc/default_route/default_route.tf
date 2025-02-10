resource "aws_route" "sol_default_route" {
  route_table_id = var.route_table_id

  # 0.0.0.0/0 로 향하는 패킷은 인터넷 게이트웨이로 전달 
  destination_cidr_block = var.destination_cidr

  # public은 gateway_id, private는 nat_gateway_id
  gateway_id = var.internet_gateway_id

  depends_on = [
    var.vpc_info,
    var.internet_gateway_info
  ]
}