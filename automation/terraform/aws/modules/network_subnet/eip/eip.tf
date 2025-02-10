# EIP may require IGW to exist prior to association. 
resource "aws_eip" "sol_eip" {
  # EIP가 VPC(가상 사설 클라우드) 환경에 할당 - NAT Gateway, Load Balancer, 또는 EC2에 연결
  domain = "vpc"
  tags = tomap({
    "Name" = var.eip_name
  })
  depends_on = [
    var.internet_gateway_id
  ]
}