resource "aws_vpc" "sol_vpc" {
  cidr_block = var.vpc_cidr

  # vpc 내에서 dns 사용  여부
  enable_dns_hostnames = true

  # dedicated - VPC 안의 모든 인스턴스가 고객 전용의 물리적 하드웨어에서 실행
  # 보안 및 규정 준수를 이유로 물리적 하드웨어 격리가 필요한 경우에 사용
  instance_tenancy = default

  tags = tomap({
    "Name" = var.vpc_name
  })
}