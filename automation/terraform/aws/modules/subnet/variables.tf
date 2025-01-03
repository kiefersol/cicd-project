variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "cidr_block" {
  description = "subnet cidr"
  type        = string
}

variable "availability_zone" {
  description = "available zone"
  type        = string
}

variable "map_public_ip_on_launch" {
  description = "type of network list. Public-true or Private-false"
  type        = string
}

variable "subnet_name" {
  description = "subnet name"
  type        = string
}

variable "vpc_name" {
  description = "vpc name"
  type        = string
}


