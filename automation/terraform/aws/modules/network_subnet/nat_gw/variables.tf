variable "eip_id" {
  description = "eip id"
  type        = string
}

variable "subnet_ip" {
  description = "subnet ip"
  type        = string
}

variable "nat_gateway_name" {
  description = "nat gateway name"
  type        = string
}

variable "internet_gateway_id" {
  description = "dependency internet gateway id"
  type        = string
}
