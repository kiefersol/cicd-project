# public subnet
resource "aws_subnet" "sol_subnet_public" {
  vpc_id                  = aws_vpc.sol_vpc.id
  cidr_block              = var.subnet_public_cidr
  availability_zone       = var.zone
  map_public_ip_on_launch = "true"  # public subnet
  tags = tomap({
      "Name" = join("-", ["${var.vpc_name}", lower("${var.zone[count.index]}"), "public","subnet" ]),
      "kubernetes.io/cluster/${var.vpc_name}" = "owned"
  })
}

# private subnet
resource "aws_subnet" "sol_subnet_private" {
  vpc_id                  = aws_vpc.sol_vpc.id
  cidr_block              = var.subnet_private_cidr
  availability_zone       = var.zone
  map_public_ip_on_launch = false    # private subnet
  tags = tomap({
      "Name" = join("-", ["${var.vpc_name}",lower("${var.zone[count.index]}"), "private","subnet" ])
      "kubernetes.io/cluster/${var.vpc_name}" = "owned"
  })
}




