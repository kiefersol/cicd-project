variable "ec2_image_code" {
  description = "ec2 image code name"
  type        = string
}

variable "ec2_product_code" {
  description = "ec2 product code name"
  type        = string
}

variable "loginkey" {
  description = "ec2 login key name"
  type        = string
}

variable "init_script" {
  description = "init script"
  type        = string
}

variable "infra_node_ip" {
  description = "infra node ip"
  type        = string
}

variable "iam_instance_profile" {
  description = "ec2 iam instance profile"
  type        = string
}

variable "nic_id" {
  description = "nic id"
  type        = string
}

variable "nic_order" {
  description = "nic order"
  type        = number
}

variable "root_block_device_size" {
  description = "root block device size"
  type        = number
}

variable "ebs_block_device_size" {
  description = "ebs block device size"
  type        = number
}

variable "ec2_name" {
  description = "ec2 name"
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
