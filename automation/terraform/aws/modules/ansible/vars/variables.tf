variable "template_file" {
  description = "template_file"
  type        = string
}

variable "cloud_provider" {
  description = "cloud_provider"
  type        = string
}

variable "nas_path" {
  description = "nas_path"
  type        = string
}

variable "nas_server" {
  description = "nas server"
  type        = string
}

variable "nas_mountoptions" {
  description = "nas mountoptions"
  type        = string
}

variable "nas_name" {
  description = "nas name"
  type        = string
}

variable "nas_dns" {
  description = "nas dns"
  type        = string
}

variable "nas_mount_path" {
  description = "nas_mount_path"
  type        = string
}

variable "region" {
  description = "region"
  type        = string
}

variable "access_key" {
  description = "access_key"
  type        = string
}

variable "secret_key" {
  description = "secret_key"
  type        = string
}

variable "system_type" {
  description = "system_type"
  type        = string
}

variable "jumpbox_ip" {
  description = "jumpbox_ip"
  type        = string
}

variable "infra_lb_domain_name" {
  description = "infra_lb_domain_name"
  type        = string
}

variable "k8s_lb_domain_name" {
  description = "k8s_lb_domain_name"
  type        = string
}

variable "infra_ip" {
  description = "infra_ip"
  type        = string
}

variable "vpc_id" {
  description = "vpc_id"
  type        = string
}

variable "vpc_name" {
  description = "vpc_name"
  type        = string
}

variable "k8s_version" {
  description = "kubernetes version"
  type        = string
}

variable "vars_file" {
  description = "vars file"
  type        = string
}

variable "asg_min_size" {
  description = "auto scaling group min size"
  type        = number
}

variable "asg_max_size" {
  description = "auto scaling group max size"
  type        = number
}

variable "k8s_pod_cidr" {
  description = "ansible k8s_pod_cidr"
  type        = string
}

variable "k8s_service_cidr" {
  description = "ansible k8s_service_cidr"
  type        = string
}

variable "master_count" {
  description = "master_count"
  type        = number
}

variable "master_ips" {
  description = "master_ips"
  type        = list(string)
}

variable "ansible_path" {
  description = "ansible_path"
  type        = string
}

variable "k8s_service_type" {
  description = "use k8s nodeport or k8s loadbalancer"
  type        = string
}