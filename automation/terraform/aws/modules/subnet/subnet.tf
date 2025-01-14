resource "aws_subnet" "sol_subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = tomap({
    "Name"                                                     = var.subnet_name,
    "kubernetes.io/cluster/${var.vpc_name}-${var.system_type}" = "owned"
  })
}