resource "aws_internet_gateway" "sol_internet_gateway" {
  vpc_id = var.vpc_id
  tags = tomap({
    "Name" = var.internet_gateway_name,
  })

  depends_on = [
    var.vpc_info
  ]
}