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
variable "k8s_manual_install" {
  description = "kubernetes manual install"
  type        = bool
}


variable "k8s_eks_install" {
  description = "kubernetes EKS install"
  type        = bool
}

variable "k8s_cluster_version" {
  description = "kubernetes EKS version"
  type        = string
}

variable "k8s_ami_make" {
  description = "kubernetes ami make"
  type        = bool
}

variable "k8s_manual_worker_asg_install" {
  description = "kubernetes autoscaling group install"
  type        = bool
}

variable "k8s_nodeport" {
  description = "k8s nodeport"
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

variable "k8s_asg_init" {
  description = "k8s auto scaling group (worker) init script"
  type        = string
}

variable "k8s_ng_init" {
  description = "k8s node group group (worker) init script"
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

variable "ansible_path" {
  description = "aansible install path"
  type        = string
}

### LB target group Variables - infra
variable "lb_infra_component_list" {
  description = "infra lb component list"
  type        = list(string)
}

variable "lb_infra_target_group_port" {
  description = "infra lb target group port"
  type        = list(number)
}

variable "lb_infra_target_group_health_check_port" {
  description = "infra lb target group health check port"
  type        = list(number)
}

variable "lb_infra_target_group_health_check_cycle" {
  description = "infra lb target group health check cycle"
  default     = 30
  type        = number
}

variable "lb_infra_target_group_health_check_up_threshold" {
  description = "infra lb target group health check up threshold"
  default     = 2
  type        = number
}

variable "lb_infra_target_group_health_check_down_threshold" {
  description = "infra lb target group health check down threshold"
  default     = 2
  type        = number
}

### LB listener variable - infra
variable "lb_infra_listener_protocol" {
  description = "infra lb listener protocol"
  default     = "TCP"
  type        = string
}

variable "lb_infra_listener_port" {
  description = "infra lb listener port"
  type        = list(number)
}

### LB target group Variables - k8s
variable "lb_k8s_component_list" {
  description = "k8s lb component list"
  type        = list(string)
}

variable "lb_k8s_target_group_port" {
  description = "k8s lb target group port"
  type        = list(number)
}

variable "lb_k8s_target_group_health_check_port" {
  description = "k8s lb target group health check port"
  type        = list(number)
}

variable "lb_k8s_target_group_health_check_cycle" {
  description = "k8s lb target group health check cycle"
  default     = 30
  type        = number
}

variable "lb_k8s_target_group_health_check_up_threshold" {
  description = "k8s lb target group health check up threshold"
  default     = 2
  type        = number
}

variable "lb_k8s_target_group_health_check_down_threshold" {
  description = "k8s lb target group health check down threshold"
  default     = 2
  type        = number
}

### LB listener variable - k8s
variable "lb_k8s_listener_protocol" {
  description = "k8s lb listener protocol"
  default     = "TCP"
  type        = string
}

variable "lb_k8s_listener_port" {
  description = "k8s lb listener port"
  type        = list(number)
}

### kubernetes Auto Scaling group
variable "k8s_asg_product_code" {
  description = "k8s_asg_product_code"
  type        = string
}

variable "k8s_asg_root_volume_size" {
  description = "k8s_asg_root_volume_size"
  type        = number
}

variable "k8s_asg_ebs_volume_size" {
  description = "k8s_asg_ebs_volume_size"
  type        = number
}

variable "k8s_ng_root_volume_size" {
  description = "k8s_ng_root_volume_size"
  type        = number
}

variable "k8s_ng_ebs_volume_size" {
  description = "k8s_ng_ebs_volume_size"
  type        = number
}

variable "k8s_asg_max_size" {
  description = "k8s_asg_max_size"
  type        = number
}

variable "k8s_asg_min_size" {
  description = "k8s_asg_min_size"
  type        = number
}

variable "k8s_asg_desired_capacity" {
  description = "k8s_asg_desired_capacity"
  type        = number
}

variable "k8s_version" {
  description = "kubernetes version"
  type        = string
}

variable "k8s_pod_cidr" {
  description = "kubernetes pod cidr"
  type        = string
}

variable "k8s_service_cidr" {
  description = "kubernetes service cidr"
  type        = string
}

variable "k8s_node_product_code" {
  description = "k8s_node_product_code"
  type        = string
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

