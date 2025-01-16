variable "sg_name" {
  description = "sg name"
  type        = string
}

variable "description" {
  description = "sg description"
  type        = string
}

variable "vpc_id" {
  description = "vpc_id "
  type        = string
}

variable "ingress_list" {
  description = "ingress_list"
  type        = list(list(string))
}

variable "egress_list" {
  description = "egress_list"
  type        = list(list(string))
}

variable "vpc_name" {
  description = "vpc name"
  type        = string
}

variable "system_type" {
  description = "system type"
  type        = string
}