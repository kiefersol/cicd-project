variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "target_group_name" {
  description = "target group name"
  type        = string
}

variable "target_group_protocol" {
  description = "target group protocol"
  type        = string
}

variable "target_group_port" {
  description = "target group port"
  type        = number
}

variable "target_group_cross_zone_enabled" {
  description = "target_group_cross_zone_enabled"
  type        = bool
}

variable "target_group_health_check_protocol" {
  description = "target group health check protocol"
  type        = string
}

variable "target_group_health_check_port" {
  description = "target group health check port"
  type        = number
}

variable "target_group_health_check_cycle" {
  description = "target group health check cycle"
  type        = number
}

variable "target_group_health_check_up_threshold" {
  description = "target group health check up threshold"
  type        = number
}

variable "target_group_health_check_down_threshold" {
  description = "target group health check down threshold"
  type        = number
}
