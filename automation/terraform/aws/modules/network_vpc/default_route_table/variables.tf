variable "default_route_table_id" {
  description = "default route table id"
  type        = string
}

variable "default_route_table_name" {
  description = "default route table name"
  type        = string
}

variable "vpc_info" {
  description = "VPC information"
  type        = list(any)
}