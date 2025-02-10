variable "eks_name" {
  description = "eks cluster name"
  type        = string
}

variable "eks_role_arn" {
  description = "eks cluster role arn"
  type        = string
}

variable "eks_version" {
  description = "eks cluster version"
  type        = string
}

variable "eks_security_group_ids" {
  description = "eks cluster security group ids"
  type        = list(string)
}

variable "eks_subnet_ids" {
  description = "eks cluster subnet ids"
  type        = list(string)
}

variable "eks_policy_AmazonEKSClusterPolicy" {
  description = "iam role policy attachment AmazonEKSClusterPolicy"
  type        = string
}

variable "eks_policy_AmazonEKSServicePolicy" {
  description = "iam role policy attachment AmazonEKSServicePolicy"
  type        = string
}

variable "eks_policy_AmazonEBSCSIDriverPolicy" {
  description = "iam role policy attachment AmazonEBSCSIDriverPolicy"
  type        = string
}







