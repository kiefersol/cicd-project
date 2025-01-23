variable "template_file" {
  description = "template_file"
  type        = string
}

variable "jumpbox_ip" {
  description = "jumpbox_ip"
  type        = string
}

variable "infra_ips" {
  description = "infra_ips"
  type        = list(string)
}

variable "master_ips" {
  description = "master_ips"
  type        = list(string)
}

variable "worker_ips" {
  description = "worker_ips"
  type        = list(string)
}

variable "master_count" {
  description = "master_count"
  type        = number
}

variable "infra_count" {
  description = "infra_count"
  type        = number
}

variable "worker_count" {
  description = "worker_count"
  type        = number
}

variable "inventory_file" {
  description = "inventory file"
  type        = string
}
