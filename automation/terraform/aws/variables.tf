# VPC
variable "vpc_install" {
  description = "vpc install"
  type        = bool
}

variable "vpc_cidr" {
  description = "vpc cidr"
  type        = string
}

variable "vpc_name" {
  description = "vpc name"
  type        = string
}

variable "region" {
  description = "vpc region"
  default     = "ap-northeast-2" # 서울
  type        = string
}

# Subnet
variable "system_type" {
  description = "system type"
  type        = string
}

variable "zone" {
  description = "availability_zone"
  type        = list(string)
}

variable "subnet_public_cidr" {
  description = "public subnet cidr"
  type        = list(string)
}

variable "subnet_private_cidr" {
  description = "private subnet cidr"
  type        = list(string)
}

variable "nat_install" {
  description = "nat install"
  type        = bool
}

variable "nas_install" {
  description = "nas install"
  type        = bool
}

variable "nas_infra_access_point" {
  description = "infra efs access point"
  type        = string
}

variable "nas_kubernetes_access_point" {
  description = "kubernetes efs access point"
  type        = string
}

# kubernetes
variable "k8s_eks_install" {
  description = "kubernetes eks install"
  type        = bool
}

variable "k8s_nodegroup_install" {
  description = "kubernetes nodegroup install"
  type        = bool
}

variable "k8s_manual_install" {
  description = "kubernetes manual install"
  type        = bool
}

variable "k8s_ami_make" {
  description = "kubernetes ami make"
  type        = bool
}

variable "k8s_manual_worker_asg_install" {
  description = "kubernetes autoscaling group install"
  type        = bool
}

# EC2
variable "infra_count" {
  description = "infra count"
  type        = number
}

variable "master_count" {
  description = "master count"
  type        = number
}

variable "worker_count" {
  description = "worker count"
  type        = number
}

# bastion ec2
variable "bastion_image_code" {
  description = "bastion vm image code"
  type        = string
}

variable "bastion_product_code" {
  description = "bastion vm product code"
  type        = string
}

variable "bastion_root_block_device_size" {
  description = "bastion_root_block_device_size"
  default     = 16
  type        = number
}

#infra ec2
variable "infra_image_code" {
  description = "infra node vm image code"
  type        = string
}

variable "infra_product_code" {
  description = "infra node vm product code"
  type        = string
}

variable "infra_root_block_device_size" {
  description = "infra root block device size"
  type        = number
}

variable "infra_ebs_root_block_device_size" {
  description = "infra ebs root block device size"
  type        = number
}

# master ec2
variable "master_image_code" {
  description = "Master node vm image code"
  type        = string
}

variable "master_product_code" {
  description = "Master node vm product code"
  type        = string
}

variable "master_root_block_device_size" {
  description = "Master root block device size"
  type        = number
}

variable "master_ebs_root_block_device_size" {
  description = "Master ebs root block device size"
  type        = number
}

# worker ec2
variable "worker_image_code" {
  description = "Worker node vm image code"
  type        = string
}

variable "worker_product_code" {
  description = "Worker node vm product code"
  type        = string
}

variable "worker_root_block_device_size" {
  description = "Worker root block device size"
  type        = number
}

variable "worker_ebs_root_block_device_size" {
  description = "Worker ebs root block device size"
  type        = number
}

variable "infra_init" {
  description = "infra node or Bastion node init script"
  type        = string
}

variable "k8s_init" {
  description = "k8s node (master, worker) init script"
  type        = string
}

variable "ansible_hosts" {
  description = "ansible host template file"
  type        = string
}

variable "ansible_vars" {
  description = "ansible vars template file"
  type        = string
}
