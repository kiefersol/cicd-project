variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "internet_gateway_name" {
  description = "internet gateway name"
  type        = string
}

variable "vpc_info" {
  description = "VPC information"
  type        = list(any)
}