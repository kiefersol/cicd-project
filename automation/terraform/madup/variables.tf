variable "region" {
  description = "vpc region"
  default     = "ap-northeast-2" # 서울
  type        = string
}

variable "vpc_cidr" {
  description = "vpc cidr"
  default     = "10.0.0.0/16"
  type        = string
}

variable "vpc_name" {
  description = "vpc name"
  default     = "madup"
  type        = string
}

variable "subnet_count" {
  description = "subnet_count"
  default     = 2
  type        = number
}

variable "subnet_mask" {
  description = "subnet_mask"
  default     = 8
  type        = number
}

variable "eks_version" {
  description = "eks_version"
  default     = "1.30"
  type        = string
}

variable "nodegroup_version" {
  description = "nodegroup_version"
  default     = "1.30"
  type        = string
}

variable "nodegroup_instance_type" {
  description = "nodegroup_instance_type"
  default     = "r5.large"
  type        = string
}

variable "nodegroup_volume_size" {
  description = "nodegroup_volume_size"
  default     = 50
  type        = number
}

variable "k8s_node_worker_size" {
  description = "Worker Node Size"
  type        = map(string)
  default = {
    "desired" = "2"
    "min"     = "1"
    "max"     = "3"
  }
}

variable "nginx_target_group_port" {
  description = "target group port"
  type        = number
}

variable "nginx_target_group_health_check_port" {
  description = "target group health check port"
  type        = number
}

variable "nginx_listener_port" {
  description = "nginx_listener_port"
  type        = number
}

variable "nginx_allow_ip" {
  description = "nginx_allow_ip"
  type        = list(string)
}


