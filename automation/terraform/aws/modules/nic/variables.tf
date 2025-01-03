variable "description" {
  description = "description of nic"
  type        = string
}

variable "subnet_id" {
  description = "subnet id"
  type        = string
}

variable "security_groups" {
  description = "target security_groups id list"
  type        = list(string)
}

variable "nic_name" {
  description = "nic name"
  type        = string
}

variable "vpc_name" {
  description = "vpc name"
  type        = string
}
