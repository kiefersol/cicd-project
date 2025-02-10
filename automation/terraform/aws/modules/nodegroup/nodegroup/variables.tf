variable "eks_name" {
  description = "eks cluster name"
  type        = string
}

variable "nodegroup_name" {
  description = "node group name"
  type        = string
}

variable "nodegroup_role_arn" {
  description = "node group role arn"
  type        = string
}

variable "nodegroup_subnet_ids" {
  description = "node group subnet ids"
  type        = list(string)
}

variable "nodegroup_launch_template_name" {
  description = "node group launch template name"
  type        = string
}

variable "nodegroup_scaling_desired" {
  description = "node group scaling desired"
  type        = number
}

variable "nodegroup_scaling_min" {
  description = "node group scaling min"
  type        = number
}

variable "nodegroup_scaling_max" {
  description = "node group scaling max"
  type        = number
}

variable "eks_policy_AmazonEKSWorkerNodePolicy" {
  description = "iam role policy attachment AmazonEKSWorkerNodePolicy"
  type        = string
}

variable "eks_policy_AmazonEKS_CNI_Policy" {
  description = "iam role policy attachment AmazonEKS_CNI_Policy"
  type        = string
}

variable "eks_policy_AmazonEC2ContainerRegistryReadOnly" {
  description = "iam role policy attachment AmazonEC2ContainerRegistryReadOnly"
  type        = string
}

variable "eks_policy_AmazonAutoScailingPolicy" {
  description = "iam role policy attachment AmazonAutoScailingPolicy"
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

