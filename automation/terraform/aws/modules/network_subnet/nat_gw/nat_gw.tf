resource "aws_nat_gateway" "sol_nat_gateway" {
  # public - 인터넷 사용하기 위함
  # private - 보안 정책상, 인터넷 액세스를 금지하고 AWS 서비스만 접근하도록 허용해야 하는 경우
  connectivity_type = "public"
  allocation_id     = var.eip_id

  # connectivity_type이 public이어서 public 서브넷 적용
  subnet_id = var.subnet_ip
  tags = tomap({
    "Name" = var.nat_gateway_name
  })
  depends_on = [
    var.internet_gateway_id
  ]
}
