variable "lb_arn" {
  description = "lb arn"
  type        = string
}

variable "listener_port" {
  description = "lb listener port"
  type        = number
}

variable "listener_protocol" {
  description = "lb listener protocol"
  type        = string
}

variable "tcp_idle_timeout" {
  description = "tcp_idle_timeout_seconds"
  type        = number
}

variable "target_group_arn" {
  description = "lb target group arn"
  type        = string
}

variable "listener_type" {
  description = "lb listener type"
  type        = string
}