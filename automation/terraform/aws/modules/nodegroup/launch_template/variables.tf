variable "nodegroup_template_name" {
  description = "node group template name"
  type        = string
}

variable "k8s_ng_init_script" {
  description = "kubernetes node group init_script"
  type        = string
}

variable "infra_node_ip" {
  description = "infra node ip"
  type        = string
}

variable "login_key_name" {
  description = "ssh login key name"
  type        = string
}

variable "nodegroup_instance_type" {
  description = "node group product code"
  type        = string
}

variable "ng_volume_size" {
  description = "node group root block device size"
  type        = number
}

variable "ng_ebs_volume_size" {
  description = "node group ebs block device size"
  type        = number
}

variable "security_groups" {
  description = "node group security groups"
  type        = list(string)
}