variable "asg_name" {
  description = "asg name"
  type        = string
}

variable "asg_subnet_ids" {
  description = "asg subnet ids"
  type        = list(string)
}

variable "asg_max_size" {
  description = "asg max size"
  type        = number
}

variable "asg_min_size" {
  description = "asg min size"
  type        = number
}

variable "asg_desired_capacity" {
  description = "asg_desired_capacity"
  type        = number
}

variable "target_group_list" {
  description = "target group list"
  type        = list(string)
}

variable "asg_template_id" {
  description = "asg template id"
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

