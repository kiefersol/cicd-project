resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  # vpc 내에서 dns 사용 여부
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = tomap({
    "Name" = var.vpc_name
  })
}

# 현재 AWS 리전에 사용 가능한 가용 영역 목록을 반환
data "aws_availability_zones" "available" {}

resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = var.subnet_count 
  map_public_ip_on_launch = true    # public subnet 지정
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, var.subnet_mask, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = tomap({
    "Name"  = join("-", ["${var.vpc_name}", count.index, "subnet"]),
    # EKS에서 EC2, 보안 그룹, 서브넷 등을 EKS 클러스터와 연결하기 위해 요구되는 태그
    "kubernetes.io/cluster/${var.vpc_name}" = "shared"
  })

  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = tomap({
    "Name" = join("-", ["${var.vpc_name}", "internet_gw"])
  })
  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_default_route_table" "default_route_table" {
  default_route_table_id = aws_vpc.vpc.main_route_table_id
  tags = tomap({
    "Name" = join("-", ["${var.vpc_name}", "main_route_table"])
  })
  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_route" "default_route" {
  route_table_id = aws_vpc.vpc.main_route_table_id

  # 0.0.0.0/0 로 향하는 패킷은 인터넷 게이트웨이로 전달 
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.internet_gateway.id

  depends_on = [
    aws_vpc.vpc,
    aws_internet_gateway.internet_gateway
  ]
}

# 특정 경로에 있는 ssh 키 가져와서 node group이나 ec2에 지정
# 경로 수정 필요 시 수정 가능
resource "aws_key_pair" "loginkey" {
  key_name   = join("-", ["${var.vpc_name}", "key"])
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDpBLW/4KDuVsSZvReq1QZ9BXAYhhYTo3X7OfKpd7fFBOgJZS9K6cnEHB/jtlaISxWvkHehVruOCeltbZG0eOTUDO+YgXkh6BIDkCxoeW4W1DLewwQ6Y7Q2I4873uFEmERgIr7X9rbbkKnmsSbiA+dHd0LSBzQbXJeCgR7Y5L+cbsATk1itNqN+8EDXAHhqr/iJJ+FNOD0cG0GvO3hGtUAqwMYmYHFpFTXrunDcKIdWcfeRz/rEAoYFSE7duUCStf8R9BP8SLyp+IxZkCM1I3gJ0ERz5ee1CZFnUeRpqashOKBCfI6NE/wlW3jUzjmlVWmATe6wZ6B+nSjsEJ1sd7AB sol@localhost.localdomain"
}