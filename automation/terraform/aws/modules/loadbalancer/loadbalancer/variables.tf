variable "lb_name" {
  description = "lb name"
  type        = string
}

variable "lb_type" {
  description = "lb type"
  type        = string
}

variable "lb_network_type" {
  description = "lb network type"
  default     = false
  type        = bool
}

variable "subnet_id_list" {
  description = "subnet id list"
  type        = list(string)
}

variable "sg_list" {
  description = "target sg id list"
  type        = list(string)
}

variable "lb_client_keep_alive" {
  description = "client_keep_alive"
  type        = number
}

variable "lb_routing_policy" {
  description = "load balancer dns_record_client_routing_policy"
  type        = string
}

variable "vpc_name" {
  description = "vpc name"
  type        = string
}

variable "system_type" {
  description = "system type"
  type        = string
}