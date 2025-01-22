variable "asg_template_name" {
  description = "asg name"
  type        = string
}

variable "asg_init_script" {
  description = "asg init script"
  type        = string
}

variable "master_node_ip" {
  description = "master node ip"
  type        = string
}

variable "k8s_lb" {
  description = "k8s lb"
  type        = string
}

variable "asg_login_key_name" {
  description = "asg login key name"
  type        = string
}

variable "asg_image_code" {
  description = "asg image code"
  type        = string
}

variable "asg_product_code" {
  description = "asg image code"
  type        = string
}

variable "asg_security_groups" {
  description = "asg security groups"
  type        = list(string)
}

variable "asg_iam_instance_profile_name" {
  description = "asg iam instance profile name"
  type        = string
}

variable "asg_volume_size" {
  description = "asg volume size"
  type        = number
}

variable "asg_ebs_volume_size" {
  description = "asg ebsvolume size"
  type        = number
}