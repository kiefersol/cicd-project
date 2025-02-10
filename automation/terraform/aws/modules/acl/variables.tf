variable "vpc_id" {
  description = "vpc_id "
  type        = string
}

variable "subnet_ids" {
  description = "subnet ids"
  type        = list(string)
}

variable "ingress_list" {
  description = "ingress_list"
  type        = list(list(string))
}

variable "egress_list" {
  description = "egress_list"
  type        = list(list(string))
}

variable "acl_name" {
  description = "acl name"
  type        = string
}