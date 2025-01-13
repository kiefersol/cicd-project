resource "aws_vpc" "sol_vpc" {
  cidr_block = var.vpc_cidr

  # vpc에서 ipv6 사용 여부
  assign_generated_ipv6_cidr_block = false

  # vpc 내에서 dns 사용 여부
  enable_dns_support = true
  enable_dns_hostnames = true

  # 네트워크 관련 주소 사용 메트릭 기능을 활성화하기 위한 속성
  # 주로 IPv4, IPv6 주소의 사용량을 추적하고 리소스 최적화 또는 네트워크 문제를 진단하는 데 유용
  enable_network_address_usage_metrics = false

  # dedicated - VPC 안의 모든 인스턴스가 고객 전용의 물리적 하드웨어에서 실행
  # 보안 및 규정 준수를 이유로 물리적 하드웨어 격리가 필요한 경우에 사용
  instance_tenancy = "default"

  tags = tomap({
    "Name" = var.vpc_name
  })
}