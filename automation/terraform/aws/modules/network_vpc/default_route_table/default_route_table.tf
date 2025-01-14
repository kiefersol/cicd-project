resource "aws_default_route_table" "sol_default_route_table" {
  default_route_table_id = var.default_route_table_id
  tags = tomap({
    "Name" = var.default_route_table_name
  })

  depends_on = [
    var.vpc_info
  ]
}