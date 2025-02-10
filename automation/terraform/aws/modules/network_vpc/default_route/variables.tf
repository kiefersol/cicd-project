variable "route_table_id" {
  description = "route table id"
  type        = string
}

variable "destination_cidr" {
  description = "destination cidr"
  type        = string
}

variable "internet_gateway_id" {
  description = "internet gateway id"
  type        = string
}

variable "vpc_info" {
  description = "dependency vpc info"
  type        = list(any)
}

variable "internet_gateway_info" {
  description = "dependency internet gateway info"
  type        = list(any)
}

